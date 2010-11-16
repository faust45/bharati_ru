class MenuGlance
  delegate :current_page?, :capture, :content_tag, :to => :helper

  attr_reader :helper

  def initialize(helper, options = {}, &block)
    @helper = helper
    @block = block
    @options = options
    @img = options[:img]
  end

  def method_missing(method, *args)
    path = @helper.send(method)
    img_path, text  = args

    cont = current_page?(path) ?
      "<strong><img width='#{@img[:width]}' height='#{@img[:height]}' src='#{img_path}'><span>#{text}</span></strong>" :
      "<a href='#{path}'><img width='#{@img[:width]}' height='#{@img[:height]}' src='#{img_path}'><span>#{text}</span></a>"

    "<li>#{cont}</li>".html_safe
  end

  def to_s
    out = ActiveSupport::SafeBuffer.new

    out.safe_concat "<ul>"
    out.safe_concat capture(self, &@block)
    out.safe_concat "</ul>"
  end
end
