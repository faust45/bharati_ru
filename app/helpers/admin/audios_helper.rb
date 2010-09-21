module Admin::AudiosHelper

  def select_authors
    options = collect_options(Author.all) {|a|
      [a.id, a.display_name]
    } 

    select_tag 'author', options
  end

  def albums
    unless @author.blank?
      @author.albums
    else
      Album.all
    end
  end

  def prepare_sub_nav
    content_for :audios_nav do
      render :partial => 'sub_nav'
    end
  end

  def object_name
    'audio'
  end

  def audio_tr(content)
    content_tag(:tr) do
      content_tag(:td, content.title) +
      content_tag(:td, link_to_edit(edit_admin_audio_path(content))) +
      content_tag(:td, link_to_del(admin_audio_path(content), :confirm => 'Are you sure?'))
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
