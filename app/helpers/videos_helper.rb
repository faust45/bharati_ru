module VideosHelper

  def video_player
    player_id = 'PlayerLigth'

    content_for(:js) do
      "initVideoPlayer('#{player_id}', '#{js_video_track_params}');"
    end
  end

  def js_video_track_params
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
