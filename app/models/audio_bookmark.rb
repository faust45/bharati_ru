class AudioBookmark < BaseModel

  property :title
  property :time, :type => Integer
  property :audio_id
  property :owner_id
  property :owner_display_name
  property :original_id
  property :original_owner_display_name
  property :is_shared


  view_by :owner_and_audio, :map => <<-MAP
    function(doc) {
      emit([doc.owner_id, doc.audio_id, doc.time], null);
    }
  MAP

  view_by :shared, :map => <<-MAP
    function(doc) {
      var is_copy = (doc.original_id != '');

      if(doc.is_shared && !is_copy) {
        emit([doc.audio_id, doc.time], null);
      }
    }
  MAP

  view_by :copy_count, :map => <<-MAP,
    function(doc) {
      if (doc.original_id) {
        emit(doc.original_id, 1);
      }
    }
  MAP
  :reduce => <<-REDUCE
    function(k, values) {
      return sum(values);
    }
  REDUCE

  class <<self
    def find_by_owner_and_audio(owner_id, audio_id)
      by_owner_and_audio(:startkey => [owner_id, audio_id], :endkey => [owner_id, audio_id, {}])
    end

    def find_shared(audio_id)
      by_shared(:startkey => [audio_id], :endkey => [audio_id, {}])
    end
  end

  def share!
    self.is_shared = true
    save
  end

  def private!
    self.is_shared = false 
    save
  end

  def copy
    bm = make_copy 

    bm.is_shared = false

    bm.original_id = self.id
    bm.original_owner_display_name = self.owner_display_name

    bm.owner_id = nil
    bm.owner_display_name = nil 

    bm
  end

  def is_shared?
    is_shared == true
  end

  def is_copy?
    !original_id.blank?
  end

end
