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
    path  = helper.send(path_method.to_s + '_path')
    title = object.send(@text_method) 
    desc  = object.send(:description) 
    photo = helper.send(@icon_method, object)

    render(:partial => "shared/#{@partial}", :locals => {:path => path, :title => title, :photo => photo, :description => desc})
  end

  def to_s
    out = ActiveSupport::SafeBuffer.new

    out.safe_concat capture(self, &@block)
  end
end
