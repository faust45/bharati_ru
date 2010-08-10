module TableHelper
  def table_for(collection, &block)
    t = TableHTML.new(collection, &block)
    t.to_s
  end

  class TableHTML
    include ActionView::Helpers::TagHelper

    def initialize(collection, &template)
      @collection = collection
      @template = template
    end

    def to_s
      content_tag(:table) do
        collection.each do |item|
          tr(item)
        end
      end
    end

    def tr(item)
      @current_item = item
      @template.bind(self).call
    end

    def td(data)
      content_tag(:td) do
        data
      end
    end

    def method_missing(method, *args)
      data = @current_item.send(method)
      td(data)
    end
  end
end
