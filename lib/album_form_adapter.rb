class AlbumFormAdapter < FormAdapter
  attr_reader :album
  alias :content :album

  def initialize(album)
    @album = album
  end

  def author_value
    album.author.display_name
  end

  class <<self
    def model
      Album
    end
  end

end
