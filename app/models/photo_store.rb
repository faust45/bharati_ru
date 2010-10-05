class PhotoStore < FileStore

  has_thumb_attachment :small, '125x125'

  class <<self
    def create(file, options = {})
      super(file, {:small_file => file, :small_options => options[:thumb]})
    end
  end

  def replace(new_file, options = {})
    super(new_file, {:small_file => new_file, :small_options => options[:thumb]})
  end

  def to_item 
    super.merge({:thumbs => {:small => small}})
  end

end
