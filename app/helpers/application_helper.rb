module ApplicationHelper

  def author_main_photo(author)
    if author.main_photo
      image_tag(file_url(author.main_photo.thumbs['small']), :width => "88", :height => "119")
    else
      ''
    end
  end

  def file_url(doc)
    "http://93.94.152.87:3000/rocks_file_store/#{doc['doc_id']}/#{doc['file_name']}"
  end

  def d(date)
    if date
      l(date.to_date, :format => :long)
    end

  rescue TypeError => ex
  end

  def collect_options(items, &block)
     items.map {|i|
       ret = yield i
       "<option value='%s'>%s</option>" % ret
     }.join.html_safe
  end

  def author_thumb(photo)
    url = thumb_url(photo)
    if url 
      image_tag(url, :width => "88", :height => "119")
    end
  end

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
      file_url(photo.thumbs['small'])
    end
  end

  def site_p
    path = site_path_items
    html = ''

    if path[:part]
      cont = path[:part]
      cont << ' > ' if path[:author]
      html << content_tag(:strong, "> #{cont}".html_safe)
    end

    if path[:author]
      html << content_tag(:i, "#{path[:author]}".html_safe)
    end

    if path[:album]
      html << content_tag(:div, path[:album], :class => 'track')
    end

    html.html_safe
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

end
