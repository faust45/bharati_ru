class MenuGlanceNext
  delegate :current_page?, :render, :capture, :content_tag, :to => :helper

  attr_reader :helper

  def initialize(helper, options = {}, &block)
    @helper  = helper
    @block   = block
    @options = options

    @icon_method = options[:icon]
    @text_method = options[:text] || :title
    @partial = 'menu_item'
    if options[:partial]
      @partial << '_' << options[:partial]
    end
  end

  def method_missing(path_method, object)
    if object.is_a?(Array) || object.is_a?(Collection)
      object.map do |item|
        render_menu_item(path_method, item)
      end.join.html_safe
    else
      render_menu_item(path_method, object)
    end
  end

  def render_menu_item(path_method, object)
    if object.is_a?(HHash) || object.is_a?(Hash)
      path  = helper.send(path_method.to_s + '_path')
    else
      path  = helper.send(path_method.to_s + '_path', object)
    end
    title = object.send(@text_method) 
    desc  = object.respond_to?(:description) && object.send(:description) 
    photo = helper.send(@icon_method, object)

    if @options[:current]
      is_current = (object == @options[:current])
    end

    render(:partial => "shared/#{@partial}", :locals => {:is_current => is_current, :path => path, :title => title, :photo => photo, :description => desc})
  end

  def to_s
    out = ActiveSupport::SafeBuffer.new

    out.safe_concat capture(self, &@block)
  end
end
