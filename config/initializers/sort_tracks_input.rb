module SimpleForm
  module Inputs
    class SortTracksInput < StringInput
      delegate :link_to, :image_tag, :to => :template

      def input
        tracks = object.get_tracks
        tracks_li = tracks.map do |t|
          template.content_tag(:li) do
            t.title +
            @builder.hidden_field('tracks', 'value' => t['_id'], :multiple => true) +
            link_to(image_tag('cancel.png'), template.album_del_track_path(object.id, t.id), :class => 'drop') +
            link_to('edit', template.edit_admin_audio_path(t.id), :class => 'edit', :target => '_blank')
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
