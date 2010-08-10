module Admin::AuthorsHelper

  def display_photo
    if name = @author.attachments.first
      content_tag(:div, :id => 'photo') do
        image_tag(@author.attachment_url(name)) + '&nbsp;&nbsp;'.html_safe +
        link_to('del', admin_authors_delete_file_path(@author, :attach => name), :remote => true)
      end
    end
  end

  def author_tr(author)
    content_tag(:tr) do
      content_tag(:td, author.display_name) +
      content_tag(:td, link_to_edit(edit_admin_author_path(author))) +
      content_tag(:td, link_to_del(admin_author_path(author))) 
    end
  end

end
