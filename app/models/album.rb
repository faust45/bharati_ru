class Album < BaseModel
  use_rand_id

  SORT_TYPE = [:custom, :by_date]

  property :title
  property :description
  property :author_id
  property :is_hand_sort, :default => false 
  property :tracks, [], :default => []

  timestamps!

  has_photo_attachment :cover, :thumb => {:size => 'x88'}


  view_by :title
  view_by :author_id

  view_by :track, :map => <<-MAP
    function(doc) {
      if(doc['couchrest-type'] == 'Album') {
        if(doc.tracks) {
          for(i in doc.tracks) {
            emit(doc.tracks[i], null);
          };
        }
      }
    }
  MAP

  search_index <<-JS 
    if(doc['couchrest-type'] && doc['couchrest-type'] == 'Album') {
      var ret = new Document();
      ret.add(doc.title, {"store": "yes"});
      return ret;
    }
  JS


  class <<self
    def get_by_title_or_create(album_name)
      album = by_title(:key => album_name)

      unless album.blank?
        album.first
      else
        create(:title => album_name)
      end
    end

    def get_by_author(author_id)
      by_author_id(:key => author_id)
    end

    def get_albums_by_track(track_id)
      self.by_albums_by_track(:key => track_id)
    end
  end

  def get_tracks
    Audio.by_album(:startkey => [self.id], :endkey => [self.id, {}])
  end

  def author
    @author ||= Author.get(author_id)
  end

  def <<(content)
    self.tracks << content.id
    self.save
  end

  def >>(content)
    self.tracks.delete(content.id)
    self.save
  end

  def display_name
    self.title
  end

end
