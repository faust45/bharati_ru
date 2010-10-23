class SitePath
  attr_reader :params
  attr_reader :helper
  delegate :ico_beta, :link_to, :content_tag, :root_path, :audios_path, :author_audios_path, :to => :helper


  def initialize(params, helper)
    @helper = helper
    @params = params
  end

  def to_s
    (main_path > audios_path > author_path > album_path > year_path > search_path).to_s
  end


  private
    def main_path
      link = link_to('<span>Бхарати<span>.ру</span></span>'.html_safe + ico_beta, root_path)
      Path.new(link)
    end

    def audios_path
      name = content_tag(:i, 'Аудио')
      link_to(name, helper.audios_path)
    end

    def author_path
      if params[:author_id]
        name = "<i>#{author.display_name}</i>".html_safe
        link_to(name, author_audios_path(author.id))
      elsif params[:album_id]
        author = album.author
        name = "<i>#{author.display_name}</i>".html_safe
        link_to(name, author_audios_path(author.id))
      end
    end

    def album_path
      if params[:album_id]
        "#{album.title}".html_safe
      end
    end

    def year_path
      if params[:year]
        "#{params[:year]}".html_safe
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
