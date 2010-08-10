module SimpleForm
  module Inputs
    class TagsAutocompleteInput < MarksAutocompleteInput

      def components_list
        [ :label, :marks, :input, :add_button, :hint, :error ]
      end

      def add_button
        template.image_tag 'add-icon.png', :class => 'add_button'
      end

    protected
      def arr_to_marks(items)
         marks = items.inject({}) do |hash, el| 
           id = el
           label = el

           hash[id] = label
           hash
         end
      end
    end
  end
end

SimpleForm::Inputs::MappingInput.map_type(:tags_autocomplete_input,  :to => :tags_autocomplete_input)
