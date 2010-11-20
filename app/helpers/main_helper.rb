module MainHelper
  def publication_photo(pub)
    photo_thumb(pub.main_photo , {:height => "88", :width => "77"}, true)
  end

  def audio_photo(audio)
    photo_thumb(audio.main_photo , {:height => "88", :width => "77"}, true)
  end
end
