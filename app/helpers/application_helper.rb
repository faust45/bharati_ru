module ApplicationHelper

  def small_thumb(photo)
    url = thumb_url(photo)
    if url 
      image_tag(url, :width => "80", :height => "97")
    end
  end

  def big_thumb(photo)
    url = thumb_url(photo)
    if url 
      image_tag(url, :width => "77", :height => "88")
    end
  end

  def thumb_url(photo)
    unless photo.blank?
      photo.thumbs['small']['url']
    end
  end

  def site_path
    site_path_items.map do |item|
      content_tag(:strong, "> #{item}")
    end.join
  end

  def content(&block)
    content_for(:content, block)
  end

  def sidebar(&block)
    content_for(:sidebar) do
      yield
    end
  end

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

  def link_to_del(url, options = {})
    options[:method] ||= :delete
    link_to(image_tag('del.png', :width => '25', :height => '25'), url, options)
  end

  def link_to_edit(url, options = {})
    link_to(image_tag('edit.png', :width => '25', :height => '25'), url, options)
  end

end
