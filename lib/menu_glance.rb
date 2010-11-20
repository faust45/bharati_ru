class MenuGlance
  delegate :current_page?, :capture, :content_tag, :to => :helper

  attr_reader :helper

  def initialize(helper, options = {}, &block)
    @helper = helper
    @block = block
    @options = options

    @icon_method = options[:icon]
    @text_method = options[:text]
  end

  def method_missing(method, options = {})
    if collection = options[:collection]
      collection.map do |item|
        path = get_path(method, item)
        render_item(path, get_icon(item), item.send(@text_method))
      end.join.html_safe
    else
      path = get_path(method)
      render_item(path, get_icon(method), get_text(method))
    end
  end

  def to_s
    out = ActiveSupport::SafeBuffer.new

    out.safe_concat "<ul>"
    out.safe_concat capture(self, &@block)
    out.safe_concat "</ul>"
  end

  private
    def render_item(path, icon, text)
      cont = current_page?(path) ?
        "<strong>#{icon}<span>#{text}</span></strong>" :
        "<a href='#{path}'>#{icon}<span>#{text}</span></a>"

      "<li>#{cont}</li>".html_safe
    end

    def get_icon(section)
      @helper.send(@icon_method, section)
    end

    def get_text(section)
      @helper.send(@text_method, section)
    end

    def get_path(section, item = nil)
      @helper.send("#{section}_path", item)
    end
end
