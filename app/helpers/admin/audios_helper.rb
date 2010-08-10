module Admin::AudiosHelper

  def object_name
    'audio'
  end

  def audio_tr(content)
    content_tag(:tr) do
      content_tag(:td, content.title) +
      content_tag(:td, link_to_edit(edit_admin_audio_path(content)))
    end
  end

  def record_place_autocomplete_path
    centers_autocomplete_path
  end

end
