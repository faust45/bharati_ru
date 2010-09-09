module Admin::AuthorsHelper

  def author_tr(author)
    content_tag(:tr) do
      content_tag(:td, author.display_name) +
      content_tag(:td, link_to_edit(edit_admin_author_path(author.id)))
      #content_tag(:td, link_to_del(admin_author_path(12))) 
    end
  end

end
