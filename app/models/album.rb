class Album < BaseModel
  use_rand_id

  SORT_TYPE = [:custom, :by_date]

  property :title
  property :description
  property :author_id
  property :is_hand_sort, :default => false 
  property :tracks, [], :default => []

  timestamps!

  has_photo_attachment :cover, :thumb => {:size => 'x77'}


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
        klass.create(:title => title)
      else
        album
      end
    end
  end

  def get_tracks
    Audio.get_by_album(self.id)
  end

  def author
    if self.author_id
      @author ||= Author.get_doc(author_id)
    end
  end

  def <<(content)
    self.tracks << content.id
    self.save
  end

  def >>(content_or_id)
    id =
      case content_or_id
      when String, Fixnum
        content_or_id.to_s
      else
        content_or_id.id
      end

    self.tracks.delete(id)
    self.save
  end

  def display_name
    self.title
  end

end
