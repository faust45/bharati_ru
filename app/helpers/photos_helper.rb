module PhotosHelper

  def album_thumb(album)
    img_id = album.photos.first
    height = 119
    width = 88
    p = "http://93.94.152.87:81/#{img_id}?size=#{height}x#{width}&thumb=1&round=1"

    image_tag(p)
  end

end