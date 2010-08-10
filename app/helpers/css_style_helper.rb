module CssStyleHelper
  class CssStyle
    DEFAULT = :white

    MAP = {:black => 'main',
           :white => 'main_w'}

    HUMAN = {:black => 'Black',
             :white => 'White'}

    def initialize(style)
      @style = (style || DEFAULT).to_sym

      unless MAP[@style]
        @style = DEFAULT
      end
    end

    def revert
      revert_style = (@style == :black ? :white : :black)
      CssStyle.new(revert_style)
    end

    def to_s
      MAP[@style]
    end

    def to_param
      @style
    end

    def human
      HUMAN[@style]
    end
  end


  def link_to_change_style
    revert_style = css_style.revert
    link_to(revert_style.human, user_change_css_style_path(:css_style => revert_style), :remote => true).html_safe
  end

  def css_style
    @css_style ||= CssStyle.new(current_user.settings[:css_style])
  end
end
