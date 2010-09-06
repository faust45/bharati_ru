module Admin::AudiosHelper

  def object_name
    'audio'
  end

  def audio_tr(content)
    content_tag(:tr) do
      content_tag(:td, content.title) +
      content_tag(:td, link_to_edit(edit_admin_audio_path(content))) +
      content_tag(:td, g_link_to_del(admin_audio_path(content), :confirm => 'Are you sure?'))
    end
  end

  def record_place_autocomplete_path
    centers_autocomplete_path
  end

  def author_autocomplete_path
    autocomplete_admin_authors_path
  end

  def index_action
    admin_audios_path
  end

end
