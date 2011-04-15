module Forum::PostsHelper

  def ans_hide?
    @comment.blank?
  end

  def render_quotes(msg)
    if quotes = msg.quotes
      s = h(msg.quotes.dup)

      s.gsub!(/\[quote(.*?)\]/) do |r|
        apply_attrs = ''

        if m = r.match(/author=['"](.*?)['"]/)
          apply_attrs = "data-author='#{m[1]}'"
        end

        "<div class='quote' #{apply_attrs}>"
      end

      s.gsub!(/\[img(.*?)\]/){|r| "<img src='#{$1}'" }
      s.gsub!(/\[\/quote\]/, '</div>') 
      s.html_safe
    end
  end

  def filter_comment(c)
    s = h(c.to_s.dup)
    s.gsub!(/\[img(.*?)\]/){|r| "<img src='#{$1}'" }
    s.html_safe
  end

end
