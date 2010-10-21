module AudiosHelper
  include AudioBookmarksHelper

  def search_path
    if params[:author_id]
      audios_search_in_author_path(params[:author_id])
    elsif params[:album_id]
      audios_search_in_album_path(params[:album_id])
    elsif params[:year]
      audios_search_in_author_year_path(params[:author], params[:year])
    end
  end

  def year_folder
    image_tag('/images/year_folder.png', :class => 'year-folder')
  end

  def link_to_author_year(year)
    img = image_tag('/images/year_folder.png', :class => 'year-folder')
    link = img + "&nbsp;&nbsp;#{year}&nbsp;&nbsp;(#{count})".html_safe
    link_to(link.html_safe, author_year_audios_path(@author.id, year))
  end

  def track_path(track)
    if @year
      author_year_audio_path(@author.id, @year, track.id)
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

  def track_img
    unless @current_track.photos.blank?
      i = rand(@current_track.photos.size)
      url = file_url(@current_track.photos[i].thumbs['small'])
      image_tag(url)
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
