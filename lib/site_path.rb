class SitePath
  attr_reader :params
  attr_reader :helper
  delegate :ico_beta, :link_to, :content_tag, :root_path, :audios_path, :author_audios_path, :to => :helper


  def initialize(params, helper)
    @helper = helper
    @params = params
  end

  def to_s
    content_tag(:div, :class => 'logo inner') do
      (main_path > audios_path > author_path > album_path > year_path).to_s
    end
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
        "<div class='track'>#{album.title}</div>".html_safe
      end
    end

    def year_path
      if params[:year]
        "<div class='track'>#{params[:year]}</div>".html_safe
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
      @path = path
    end

    def >(path)
      if path
        @path << "<strong><i>&gt;</i></strong>".html_safe + path
      end

      self
    end

    def to_s
      @path.html_safe
    end
  end

end
