class SitePath
  attr_reader :params
  attr_reader :helper
  delegate :author_videos_path, :ico_beta, :link_to, :content_tag, :root_path, :audios_path, :author_audios_path, :to => :helper


  def initialize(params, helper)
    @helper = helper
    @params = params
  end

  def to_s
    (main_path > photos_path > videos_path > about_path > events_path > audios_path > audio_books_path > audio_books_one_path > publications_path > photo_album > publications_album > publication_title > bhagavatam_author > author_path > 
      bhagavatam_album > album_path > year_path > search_path).to_s
  end


  private
    def main_path
      link = link_to('<span>Бхарати<span>.ру</span></span>'.html_safe + ico_beta, root_path)
      Path.new(link)
    end

    def audio_books_path
      actions = %w(books books_vaishnava books_classic)
      if params[:controller] == "audios"
        case params[:action]
        when 'books_vaishnava'
          title = 'Вайшнавские аудиокниги'
          path  = helper.audio_books_vaishnava_path
        when 'books_classic'
          title = 'Вайшнавские идеи в произведениях классиков'
          path  = helper.audio_books_classic_path
        when 'books'
          title = 'Аудиокниги'
          path  = helper.audio_books_vaishnava_path
        else
          return
        end

        name = content_tag(:i, title)
        link_to(name, path)
      end
    end

    def audio_books_one_path
      if params[:controller] == "audios" && params[:action] == 'books'
        book = AudioBook.get_doc(params[:id])
        book.title.html_safe
      end
    end

    def photos_path
      if params[:controller] == "photos"
        name = content_tag(:i, 'Фото')
        link_to(name, helper.photos_path)
      end
    end

    def videos_path
      if params[:controller] == "videos"
        name = content_tag(:i, 'Видео')
        link_to(name, helper.videos_path)
      end
    end

    def about_path
      if params[:controller] == "about"
        name = content_tag(:i, 'О сайте')
        link_to(name, helper.about_path)
      end
    end

    def events_path
      if params[:controller] == "events"
        name = content_tag(:i, 'События')
        link_to(name, helper.events_path)
      end
    end

    def bhagavatam_author
      if params[:controller] == "audios" and params[:action] == "bhagavatam"
        author_id = 'BharatiMj'
        author = Author.display_name_by_id(author_id)
        name = "<i>#{author}</i>".html_safe
        link_to(name, author_audios_path(author_id))
      end
    end

    def bhagavatam_album
      if params[:controller] == "audios" and params[:action] == "bhagavatam"
        album = Album.get_doc('Bhagavatam')
        album.title.html_safe
      end
    end

    def audios_path
      if params[:controller] == "audios"
        name = content_tag(:i, 'Аудио')
        link_to(name, helper.audios_path)
      end
    end

    def publications_path
      if params[:controller] == "publications"
        name = content_tag(:i, 'Библиотека')
        link_to(name, helper.publications_path)
      end
    end

    def publication_title
      if params[:controller] == "publications" and params[:action] == "show"
        @publication ||= Publication.get_doc(params[:id])
        content_tag(:i, @publication.title)
      end
    end

    def publications_album
      if params[:controller] == "publications" and params[:action] == "album"
        @album ||= AlbumPublication.get_doc(params[:album_id])
        content_tag(:i, @album.title)
      end
    end

    def photo_album
      if params[:controller] == "photos" and params[:action] == "album"
        album ||= PhotoAlbum.get_doc(params[:id])
        content_tag(:i, album.title)
      end
    end

    def author_path
      if params[:author_id]
        name = "<i>#{author.display_name}</i>".html_safe
        if params[:controller] == 'audios'
          link_to(name, author_audios_path(author.id))
        elsif params[:controller] == 'videos'
          link_to(name, author_videos_path(author.id))
        end
      elsif params[:album_id]
        author = album.author
        name = "<i>#{author.display_name}</i>".html_safe
        if params[:controller] == 'audios'
          link_to(name, author_audios_path(author.id))
        elsif params[:controller] == 'videos'
          link_to(name, author_videos_path(author.id))
        end
      end
    end

    def album_path
      if params[:controller] == 'audios' && params[:album_id]
        "#{album.title}".html_safe
      end
    end

    def year_path
      if params[:year]
        "#{params[:year]} год".html_safe
      end
    end

    def search_path
      if params[:q]
        RawItem.new "поиск по слову “#{params[:q]}”".html_safe
      end
    end

    def author
      @author ||= Author.get_doc!(params[:author_id])
    end

    def album
      @album ||= Album.get_doc!(params[:album_id])
    end

    def wrap(str)
      content_tag(:i, str)
    end

  class Path
    def initialize(path)
      @path_items = []
      @path_items << path
    end

    def >(path)
      if path
        @path_items << path
      end

      self
    end

    def pointer 
      "<strong><i>&gt;</i></strong>".html_safe
    end

    def to_s
      first_line = @path_items[0..2]
      second_line = @path_items.from(3)

      first_line.map! {|el|
        if el.is_a?(RawItem)
          "<i>#{el.to_s}</i>"
        else
          el
        end
      }
      html = first_line.join(pointer)

      if second_line.any?
        html << pointer
      end

      cont = "<div class='logo inner'>#{html}</div>".html_safe
      if second_line.any?
        cont << "<div class='track'>#{second_line.join("&nbsp;#{pointer}&nbsp;")}</div>".html_safe
      end

      cont
    end
  end

  class RawItem < Struct.new(:cont)
    def to_s
      cont
    end
  end

end
