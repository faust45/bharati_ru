class AuthorMainPhotoStore < FileStore
  #один тип: 77на88 второй тип: 88 на 120 третий тип: 280 на 202 четвертый тип:  176 на 224

  has_photo_attachment :small,  '88x120'
  has_photo_attachment :middle, '280x202'


  def self.create(file, options = {})
    super(file, {:small_file => file, :middle_file => file})
  end

  def to_item 
    super.merge({:thumbs => {:small => small, :middle => middle}})
  end

end
