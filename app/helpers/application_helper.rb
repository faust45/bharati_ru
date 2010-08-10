module ApplicationHelper

  def strong(text)
    content_tag(:strong, text)
  end

  def include_js(*names)
    content_for(:include_js) do
      javascript_include_tag(*names)
    end
  end

  def title(text)
    content_tag(:p, text)
  end

  def g_link_to_del(url, options = {})
    options[:method] ||= :delete
    link_to image_tag('del.png'), url, options
  end

  def g_link_to_del(url, options = {})
    options[:method] ||= :delete
    link_to image_tag('del.png'), url, options
  end

  def link_to_edit(url, options = {})
    link_to(image_tag('edit.jpg', :width => '20', :height => '20'), url)
  end

end
