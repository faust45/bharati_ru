module AudiosHelper
  include AudioBookmarksHelper

  def track_path(track)
    if @year
      year_audios_path(@year, track.id)
    else
      album_track_path(@album.id, track.id)
    end
  end

  def random_author_photo(author)
    photo = author.photos.first
    image_tag photo.thumbs['small']['url'] if photo
  end

  def is_selected_author?(author_item)
    @current_author == author_item
  end

  def site_path_items
    ['Аудио', @author.display_name]
  end

  def track_img
    unless @current_track.photos.blank?
      image_tag(@current_track.photos.first.thumbs['small']['url']) 
    end
  end

  def player
    content_for :before_main_block do
      render :partial => 'player'
    end
  end

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
    unless @current_track.tags.blank?
      @current_track.tags.map{|t|
        link_to t, ''
      }.join(',&nbsp;').html_safe
    end
  end

  def source_size(doc)
    attach = FileStore.get(doc.source.doc_id)
    attachment_size(attach, doc.source.file_name)
  end

  def attachment_size(doc, file_name)
    if doc['_attachments']
      size = (doc['_attachments'][file_name]['length'].to_i / 1024 / 1024)
      "#{size} Мб"
    else
      "Blank"
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
      :album_name  => escape(@album.title),
      :author_name => @current_track.author.display_name,
      :track_name  => @current_track.title,
      :track_url   => file_url(@current_track.source),
      :track_duration => @current_track.duration,
    }

    options.map do |key, value|
      "#{key}=#{value}" 
    end.join('&')
  end

  def escape(str)
    str.gsub(/\"/, ' ')
  end

end
