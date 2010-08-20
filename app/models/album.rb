class Album < BaseModel
  use_rand_id

  SORT_TYPE = [:custom, :by_date]

  property :title
  property :description
  property :sort_type, :default => :by_date
  property :tracks, [], :default => []

  has_attachment :cover


  view_by :title

  view_by :traks_by_album, :map => <<-MAP
    function(doc) {
      if(doc['couchrest-type'] == 'Album') {
        if(doc.tracks) {
          for(i in doc.tracks) {
            var track = doc.tracks[i];
            emit([doc['_id'], i], {'_id': track});
          };
        }
      }
    }
  MAP

  view_by :albums_by_track, :map => <<-MAP
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


  def self.get_by_name_or_create(album_name)
    album = by_title(:key => album_name)

    unless album.blank?
      album.first
    else
      create(:title => album_name)
    end
  end

  def get_tracks
    self.class.by_traks_by_album(:startkey => [self.id], :endkey => [self.id, {}])
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
