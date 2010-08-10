module SimpleForm
  module Inputs
    class ListEditInput < Base
      def input
        template.render(:partial => 'add_bookmark')
      end

      def components_list
        [ :label, :bookmarks, :input, :hint, :error ]
      end

      def bookmarks
        items = object.send(attribute_name)
        template.content_tag(:div, list(items), :class => 'bookmarks')
      end

      def input_html_options
      end

    protected
      def list(items)
        template.content_tag(:ul) do
          items.map do |item|
            template.content_tag(:li, item.title, 'data-time' => item.time)
          end.join
        end
      end
    end
  end
end

SimpleForm::Inputs::MappingInput.map_type(:list_edit_input, :to => :list_edit_input)
