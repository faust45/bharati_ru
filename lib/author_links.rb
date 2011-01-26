class AuthorLinks
  delegate :current_page?, :link_to, :render, :capture, :content_tag, :to => :helper

  attr_reader :helper

  def initialize(helper, object, &block)
    @helper = helper
    @object = object
    @block = block
  end
 
  def method_missing(url_method, title, options = {})
    if url = @object.send(url_method)
      link_to(title, url, options)
    end
  end

  def to_s
    out = ActiveSupport::SafeBuffer.new
    out.safe_concat capture(self, &@block)
  end
end
