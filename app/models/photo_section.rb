class PhotoSection < BaseModel 

  MATH = %w(Teachers Preachers Temples)
  BS   = %w(Public Countries Pilgrimages)
  Scripts = %w(SrimadBhagavatam)

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
      BS.map {|id|
        get_all.find{|el| el.id == id }
      }
    end

    def get_scripts
      get_all.find_all{|el| Scripts.include?(el.id) }
    end
  end

  def cover
    @album ||= PhotoAlbum.get_doc(albums.first)
    @album.photos.first
  end

end
