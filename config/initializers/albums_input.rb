module SimpleForm
  module Inputs
    class AlbumsInput < StringInput

      def input
        return if object.new?
        audio_id = object['_id']
        add_url = lambda {|album_id| template.send("album_add_track_path", album_id, audio_id) }
        del_url = lambda {|album_id| template.send("album_del_track_path", album_id, audio_id) }

        selected_albums = object.albums
        albums = Album.all.map do |a|
          album_id = a['_id']
          cclass = 'selected' if selected_albums.include?(a)
          template.content_tag(:li, a.title, :class => cclass, 
                                             'data-add-url' => add_url.call(album_id),
                                             'data-del-url' => del_url.call(album_id))
        end

        template.content_tag(:ul, albums.join.html_safe, :class => 'albums')
      end

      def components_list
        [ :label, :input, :hint, :error ]
      end
    end

  end
end

SimpleForm::Inputs::MappingInput.map_type(:albums_input,  :to => :albums_input)
