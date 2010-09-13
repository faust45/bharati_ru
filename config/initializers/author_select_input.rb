module SimpleForm
  module Inputs
    class AuthorSelectInput < CollectionInput
      def input
        collection = Array(options[:collection] || authors)
        detect_collection_methods(collection, options)
        @builder.send(:"collection_#{input_type}", attribute_name, collection, options[:value_method],
                      options[:label_method], input_options, input_html_options)
      end

      def input_type
        'select'
      end

      def authors 
        Author.all.map{|a| [a.display_name, a.id]}
      end
    end
  end
end
