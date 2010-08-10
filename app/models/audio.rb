class Audio < MediaContent

  Types = %w(lecture seminar appeal kirtan music)

  property :duration

  has_attachment :source
  has_attachment :photos

  #
  #Audio.find_in_album(id, position)
  view_by :album, :map => <<-MAP
    function(doc) {
      if(doc['couchrest-type'] == 'Audio') {
        emit(doc['_id'], {'_id': doc.author.id});
      }
    }
  MAP


  before_save_source_attachment do
    info = Mp3Info.open(@file.path)
    self.duration = calc_duration(info)
    @content_type = 'audio/mpeg'
  end

    
  def albums
    @albums ||= Album.by_albums_by_track(:key => self.id)
  end

  class <<self
    def find_in_album(album_id, position)
      by_album(:key => [album_id.to_s, position.to_i])
    end
  end

  def shared_bookmarks
    AudioBookmark.find_shared(self.id)
  end

  def new_bookmark(options = {})
    bm = AudioBookmark.new(options)
    bm.audio_id = self.id
    bm
  end

  private
    def calc_duration(info)
      l = info.length
      mins = l.divmod(60)

      if mins[0] == 0
        min = mins[0]
        sec = mins[1].round
      else
        min = mins[0]
        sec = mins[1].round
      end
    
      (min * 60 + sec) * 1000
    end

end
