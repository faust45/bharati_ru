module AudiosHelper
  include ImagesHelper

  def text_format(text)
    text.to_s.gsub(/$/, "\n<br />")
  end

  def link_to_teacher(author)
    if author.is_teacher?
      teacher_show_path(author)
    else
      preacher_show_path(author)
    end

  end

  def audio_book_icon(book_type)
    photo_thumb_round(book_type.icon, Images::MENU_BOOKS)
  end

  def author_path(author)
    if author.is_teacher?
      teacher_show_path(author)
    else
      about_author_path(author)
    end
  end

  def sb_book_title(book)
    options = {:class => "hover"} if book == @album

    content_tag(:li, options) do
      link_to book.title, audios_bhagavatam_book_path(book.book_num)
    end
  end

  def li_month(month)
    month, count = month
    options = {:class => "hover"} if month == @month

    content_tag(:li, options) do
      link_to ru_month(month), author_year_month_audios_path(@author.id, @year, month)
    end
  end

  def author_name
    if @author
      @author.display_name
    else
      @album.author.display_name
    end
  end

  def search_path
    if params[:author_id] && params[:year]
      audios_search_in_author_year_path(params[:author_id], params[:year])
    elsif params[:author_id]
      audios_search_in_author_path(params[:author_id])
    elsif params[:album_id]
      audios_search_in_album_path(params[:album_id])
    else
      audios_search_path
    end
  end

  def link_to_author_year(year)
    img = image_tag('/images/year_folder.png', :class => 'year-folder')
    link = img + "&nbsp;&nbsp;#{year}&nbsp;&nbsp;(#{count})".html_safe
    link_to(link.html_safe, author_year_audios_path(@author.id, year))
  end

  def track_path(track)
    if @year
      author_year_month_track_path(@author.id, @year, @month, track.id)
    elsif @album.is_a?(SbAlbum)
      audios_bhagavatam_track_path(@album.book_num, track.id)
    else
      album_track_path(@album, track.id)
    end
  end

  def random_author_photo(author)
    photo = author.photos.first
    image_tag photo.thumbs['small']['url'] if photo
  end

  def track_img
    unless @current_track.photos.blank?
      i = rand(@current_track.photos.size)
      url = file_url(@current_track.photos[i].thumbs['small'])
      image_tag(url)
    end
  end

  def track_img_url
    unless @current_track.photos.blank?
      i = rand(@current_track.photos.size)
      file_url(@current_track.photos[i].thumbs['small'])
    end
  end

  def player
      render :partial => 'player'
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
      :title => escape(@current_track.title),
      :file  => file_url(@current_track.source),
      :duration => @current_track.duration,
      :addBookmarkButton => false,
      :addToFavoriteButton => false
    }

    options.map do |key, value|
      "#{key}=#{value}" 
    end.join('&')
  end

  def escape(str)
    str.gsub(/\"/, ' ')
  end

end
