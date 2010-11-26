module VideosHelper

  def main_menu_path
    #main_path do
    #  videos('Видео') > author > year > show
    #end
  end

  def show_video(video)
    if video.record_date
      year = video.record_date.slice(0, 4)
      show_author_year_video_path(video.author, year, video)
    else
      show_author_video_path(video.author, video)
    end
  end

  def is_current?(video) 
    current_page?(show_video(video))
  end

  def video_player
    player_id = 'PlayerLigth'

    content_for(:js) do
      "initVideoPlayer('#{player_id}', '#{js_video_params}');"
    end
  end

  def js_video_params
    options = {
      :type => "video",
      :version => "1.0",
      :provider_name => "Vimeo",
      :provider_url => "http://www.vimeo.com/",
      :clip_id => @video.vimeo_id
    }

    options.map do |key, value|
      "#{key}=#{value}" 
    end.join('&')
  end

end
