module Admin::AlbumsHelper
  include ApplicationHelper

  def album_tr(content)
    content_tag(:tr) do
      content_tag(:td, content.title) +
      content_tag(:td, link_to_edit(edit_admin_album_path(content))) +
      content_tag(:td, g_link_to_del(admin_album_path(content)))
    end
  end
end
