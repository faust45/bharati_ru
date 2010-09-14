module AdminHelper
  def context_nav
    content_for :context_nav do
      yield
    end
  end

  def render_sidebar
    prepare_sub_nav

    render :partial => './admin/shared/sidebar'
  end

  def author_item(author)
    css_class = []
    css_class << 'author_item'
    css_class << 'active' if author == @author

    content_tag(:li, :class => css_class.join(' ')) do
      link_to author.display_name, admin_author_audios_path(author)
    end
  end

  def authors
    Author.all
  end
end
