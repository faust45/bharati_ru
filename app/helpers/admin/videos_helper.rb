module Admin::VideosHelper

  def embed(video)
    s = "<iframe src='http://player.vimeo.com/video/#{video.id}?byline=0&amp;portrait=0&amp;color=fcf2eb' width='640' height='358' frameborder='0'> </iframe>"
    s.html_safe
  end


end
