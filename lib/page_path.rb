class PagePath
  attr_reader :helper
  delegate :ico_beta, :link_to, :content_tag, :root_path, :to => :helper

  def initialize(helper, &block)
    @helper = helper
    @block = block
    @prefix = ''
    @path = Path.new(helper)
  end

  def to_s
    @block.bind(self).call

    @path.to_s
  end

  def method_missing(method, *args)
    text = args.first

    @path.add(method, text)
  end

  def main_path
    link_to('<span>Бхарати<span>.ру</span></span>'.html_safe + ico_beta, root_path)
  end

  class Path
    attr_reader :routes

    def initialize(routes)
      @routes = routes
      @first_item = ''
      @prefix_parts = [] 
      @parts  = []
      @values = {}
    end

    def current_path
      collect_values
      collect_paths
    end

    def add(item, text)
      el = {
        :item => item,
        :title => text
      }

      if @root.blank?
        @root = el 
      else
        @parts << el
      end
    end

    def collect_values
      @first_item = @root[:item]
      path_for(@root)

      @parts.each do |p|
        item = p[:item]
        value = routes.instance_variable_get("@#{item}")
      end
    end

    def to_s
      @parts.each do |part|
        helper.link_to(part[:title], part[:path])
      end
    end

    private
      def path_for(item)
        routes.send("#{item}_path", *values)
      end

      def values
        @prefix_parts.map{|p| value_for(p) }
      end

      def value_for(item)
      end

      def path_method(item)
        if @prefix.blank?
          @first_item = item
          item
        else
          @prefix_parts << item
          @prefix_parts.join('_') + @first_item
        end
      end
  end

end
