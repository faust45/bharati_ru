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
    l(date.to_date, :format => :long)

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
    main_item = path.shift
    main_item = content_tag(:strong, "> #{main_item.html_safe}".html_safe)

    main_item +
    path.map do |item|
      content_tag(:i, "> #{item.html_safe}".html_safe)
    end.join.html_safe
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
