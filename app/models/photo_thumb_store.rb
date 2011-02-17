class PhotoThumbStore < FileStore
  attr_reader :tmp_image

  property :size
  property :thumb_type

  before_save :setup
  before_save :resize
  before_save :convert_to_png
  before_save :rounded_corners

  private
    def setup
      @tmp_image ||= MiniMagick::Image.from_file(file_path)
      self.file = Tempfile.new('temp')
      @temp_file = Tempfile.new('temp')
    end

    def resize
     # if tmp_image[:width] < tmp_image[:height]
     #   remove = ((tmp_image[:height] - tmp_image[:width])/2).round
     #   tmp_image.resize("x#{remove}")
     # else tmp_image[:height] < tmp_image[:width]
     #   remove = ((tmp_image[:width] - tmp_image[:height]) / 2).round
     #   tmp_image.resize("#{remove}x")
     # end
      
     tmp_image.resize size
    end
  
    def convert_to_png
      `./script/convert.sh #{tmp_image.tempfile.path} #{@temp_file.path}.png`
    end

    def rounded_corners
      `./script/rounded_corners.sh #{@temp_file.path}.png #{file.path}`
    end
  
    def prepare_file_name
      "#{thumb_type}.png" 
    end

end
