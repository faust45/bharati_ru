module SimpleForm
  module Inputs
    class MarksAutocompleteInput < StringInput

      def input
        @builder.text_field("#{attribute_name}_value", input_html_options)
      end

      def components_list
        [ :label, :marks, :input, :hint, :error ]
      end

      def marks
        template.content_tag(:div, :class => 'marks') do
          items = object.send(attribute_name)
          marks = arr_to_marks(items)
          url = template.send("autocomplete_#{attribute_name}_path")

          @builder.hidden_field(attribute_name,
            :multiple  => true,
            'data-url' => url,
            'data-marks' => marks.to_json,
            :value => ''
          )
        end
      end

      def input_html_options
        input_options = super
        input_options[:value] ||= ''
        input_options[:name]  = 'autocomplete'
        input_options[:class] = "autocomplete #{input_options[:class]}"

        input_options
      end

    protected

      def arr_to_marks(items)
         marks = items.inject({}) do |hash, el| 
           id = el.id
           label = el.display_name

           hash[id] = label
           hash
         end
      end
    end
  end
end

SimpleForm::Inputs::MappingInput.map_type(:marks_autocomplete_input,  :to => :marks_autocomplete_input)
