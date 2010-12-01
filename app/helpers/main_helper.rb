module MainHelper
  def publication_photo(pub)
    photo_thumb(pub.main_photo , {:height => "88", :width => "77"}, true)
  end

  def photo_news(event)
    photo_thumb(event.main_photo , {:height => "97", :width => "80"}, true)
  end

  def video_photo(video)
    image_tag video.thumbnail_small
  end

  def audio_photo(audio)
    photo_thumb(audio.main_photo , {:height => "88", :width => "77"}, true)
  end
end
