class BigPhotoThumbStore < FileStore
  attr_reader :tmp_image

  property :size
  property :thumb_type

  before_save :setup
  before_save :resize
  #before_save :convert
  before_put_attachment_directly :set_file

  private
    def setup
      @tmp_image ||= MiniMagick::Image.from_file(file.path)
    end

    def resize
      tmp_image.resize size
    end
  
    def convert
      tmp_image.format('jpg')
    end

    def prepare_file_name
      "#{thumb_type}.jpg"
    end

    def set_file
      self.file = File.open(@tmp_image.tempfile.path)
    end

end
