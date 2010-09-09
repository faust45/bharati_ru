class BigPhotoStore < FileStore

  has_big_thumb_attachment :small, '280x200'


  def self.create(file, options = {})
    super(file, {:small_file => file})
  end

  def replace(new_file, options = {})
    super(new_file, {:small_file => new_file})
  end

  def to_item 
    super.merge({:thumbs => {:small => small}})
  end

end
