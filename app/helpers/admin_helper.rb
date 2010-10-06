module AdminHelper
  def context_nav
    content_for :context_nav do
      yield
    end
  end

  def render_sidebar
    content_for space do
      render :partial => 'sub_nav'
    end

    render :partial => './admin/shared/sidebar'
  end

  def author_item(author)
    css_class = []
    css_class << 'active' if author == @author

    content_tag(:li) do
      link_to author.display_name, admin_author_audios_path(author)
    end
  end

  def authors
    Author.all
  end
end
