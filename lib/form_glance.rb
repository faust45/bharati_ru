class FormGlance
  delegate :capture, :concat, :content_tag, :to => :helper

  attr_reader :helper

  def initialize(feedback, helper, options = {}, &block)
    @helper = helper
    @doc = feedback
    @block = block
    @options = options
    @method = options[:method] || "POST"
  end

  def to_s
    out = ActiveSupport::SafeBuffer.new

    out.safe_concat "<form method=#{@method}>"
    out.safe_concat capture(self, &@block)
    out.safe_concat "</form>"
  end

  def bug
    if @doc.errors.any?
      safe <<-HTML
         <div class="bug-t">
            <div class="bug-b">
              <div class="bug">
                <p>Вы неправильно заполнили форму.</p> 
              </div>
            </div>
        </div>
        <div class="fault"> </div>
      HTML
    end
  end

  def title(text)
    "<p class='tit'>#{text}:</p>".html_safe
  end

  def string(attr)
    label(attr) +
    content_tag(:div, :class => "bloc") do
      content_tag(:div, :class => "inp") do
        "<input type='text' name='#{f_name(attr)}' value='#{value(attr)}'>".html_safe
      end
    end + error(attr) + cl
  end

  def text(attr)
    label(attr, 'left') + error(attr) + cl +
    content_tag(:div, :class => "area") do
      "<textarea name='#{f_name(attr)}'>#{value(attr)}</textarea>".html_safe
    end
  end

  def submit
    '<input type="submit" value="Отправить" class="butt">'.html_safe
  end

  def label(attr, html_class = '')
    "<p class='#{html_class}'>#{t_label(attr)}:</p>".html_safe
  rescue I18n::MissingTranslationData
  end

  def error(attr)
    if @doc.errors[attr]
      "<span>#{t_error(attr)}</span>".html_safe
    end
  rescue I18n::MissingTranslationData
  end

  def cl
    '<div class="cl"></div>'.html_safe
  end

  private
    def safe(text)
      text.html_safe
    end

    def value(attr)
      @doc.send(attr)
    end

    def f_name(attr)
      "#{model_name}[#{attr}]"
    end

    def t_label(attr)
      I18n.t!("views.labels.#{model_name}.#{attr}")
    end
    
    def t_error(attr)
      @doc.errors[attr]
    end

    def model_name
      @doc.class.model_name.singular
    end
end
