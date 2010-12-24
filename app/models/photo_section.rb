class PhotoSection < BaseModel 

  MATH = %w(Teachers Preachers Temples)
  BS   = %w(Public Countries Pilgrimages)

  property :title
  property :albums, []

  class <<self
    def get_all(options = {})
      options[:descending] ||= true
      @all ||= view_docs('photo_sections', options)
    end

    def get_math
      get_all.find_all{|el| MATH.include?(el.id) }
    end

    def get_bs
      get_all.find_all{|el| BS.include?(el.id) }
    end
  end

  def cover
    @album ||= PhotoAlbum.get_doc(albums.first)
    @album.photos.first
  end

end
