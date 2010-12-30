module ImagesHelper

  module Images
    MENU = {:width => 88, :height => 119}
    MENU_BOOKS = {:width => 96, :height => 98, :thumb => true}
  end

  def cover_thumb(item)
    photo_thumb(item.cover, {:width =>91, :height => 119}, true)
  end

  def photo_thumb_round(img_id, size)
    photo_thumb(img_id, size, true) 
  end

  def photo_thumb(img_id, size, round = false) 
    image_tag(photo_thumb_url(img_id, size, round))
  end

  def photo_thumb_url(img_id, size, round = false) 
    p = "http://photos.bharati.ru/#{img_id}?size=#{size[:height]}x#{size[:width]}"
    p << "&thumb=1" if size[:thumb] 
    p << "&round=1" if round
    p
  end

end
