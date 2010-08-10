module AudiosHelper
  include AudioBookmarksHelper

  def album_navigation
    tracks = []
    @album.tracks.each_with_index do |track_id, i|
      tracks << content_tag(:li) do
        link_to(i + 1, audio_path(track_id)) 
      end
    end

    content_tag(:ul, tracks.join.html_safe, :class => 'nav')
  end

  def tags
    @audio.tags.map{|t|
      link_to t, ''
    }.join(',').html_safe
  end

  def attachment_url
    @audio.attachment_url(@audio.source_attachments.first)
  end

  def attachment_size
    if @audio['_attachments']
      attach = @audio.source_attachments.first
      size = (@audio['_attachments'][attach]['length'].to_i / 1024 / 1024)
      "#{size} Mb"
    end
  end

  def js_gen_player
    player_id = 'PlayerLigth'

    content_for(:js) do
      "initPlayer('#{player_id}', '#{js_track_params}');"
    end
  end

  #
  #Extract:
  #  author_name, album_name, track_name, track_url, user_bookmarks, author_bookmarks 
  #  track_duration (required)
  def js_track_params
    options = {
      :album_name  => @album.title,
      :author_name => @audio.author[:name],
      :track_name  => @audio.title,
      :track_url   => attachment_url,
      :track_duration => @audio.duration,
      :author_bookmarks => @author_bookmarks.map(&:time).join(','),
      :user_bookmarks   => @bookmarks.map(&:time).join(',') 
    }

    options.map do |key, value|
      "#{key}=#{value}" 
    end.join('&')
  end

end
