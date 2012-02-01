class Album < AlbumBase

  class <<self
    def get_all
      view_docs('albums_by_author')
    end

    def get_by_author(author_id)
      view_docs('albums_by_author', :key => author_id)
    end

    def get_by_track(track_id)
      view_docs('albums_by_track', :key => track_id)
    end

    def get_by_title(title)
       albums = view_docs('albums_by_title', :key => title)
       albums.first
    end

    def get_by_title_or_create(title)
      klass = SbAlbum::TITLE =~ title ? SbAlbum : Album

      album = klass.get_by_title(title)
      if album.blank?
        #Just have some issue with parsing ID3 tags for SbAlbums, thats why we avoid create albums for SB from tags
        klass.create(:title => title) if klass == Album
      else
        album
      end
    end
  end

  def to_s
    title
  end

  def tracks_count
    if self.id == 'Bhagavatam'
      resp = view('sb_albums_by_track', :limit => 0)
      resp['total_rows']
    else
      tracks.size
    end
  end

end
