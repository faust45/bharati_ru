class PhotoAlbum < BaseModel

  property :title
  property :photos, []


  class <<self
    def get_all(options = {})
      options[:descending] ||= true
      view_docs('photo_albums', options)
    end
  end

end
