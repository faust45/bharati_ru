class PhotoThumbStore < FileStore

  property :size
  property :thumb_type

  before_save :setup
  before_save :resize
  before_save :convert_to_png
  before_save :rounded_corners

  private
    def setup
      @tmp_image = MiniMagick::Image.from_file(file.path)
      self.file = Tempfile.new('temp')
    end

    def resize
      @tmp_image.resize size
    end
  
    def convert_to_png
      @tmp_image.format('png')
    end
  
    def rounded_corners
      `./script/rounded_corners.sh #{@tmp_image.tempfile.path} #{file.path}`
    end
  
    def prepare_file_name
      "#{thumb_type}.png" 
    end

end
