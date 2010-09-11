module SimpleForm
  module Inputs
    class SortTracksInput < StringInput
      delegate :content_tag, :link_to_del, :link_to_edit, :link_to, :image_tag, :to => :template

      def input
        tracks = object.get_tracks
        tracks_li = tracks.map do |t|
          content_tag(:li) do
            t.title +
            content_tag(:div, :class => 'edit_block') do
              link_to_edit(template.edit_admin_audio_path(t.id), :class => 'edit', :target => '_blank') +
              link_to_del(template.album_del_track_path(object.id, t.id), :class => 'drop')
            end +
            @builder.hidden_field('tracks', 'value' => t['_id'], :multiple => true)
          end
        end

        template.content_tag(:ul, tracks_li.join.html_safe, :id => 'tracks', :class => "ui-sortable")
      end

      def components_list
        [ :label, :input, :hint, :error ]
      end
    end

  end
end

SimpleForm::Inputs::MappingInput.map_type(:sort_tracks_input,  :to => :sort_tracks_input)
