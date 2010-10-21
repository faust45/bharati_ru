module ApplicationHelper

  def ico_beta
    image_tag('/images/beta.png', :class => 'beta')
  end

  def current_page
    @page ||= (params[:page] || 1).to_i
  end

  def pages(total)
    if total.respond_to?(:total_rows)
      total = total.total_rows
    end

    range = range_pages(total).to_a
    if range.size > 1
      render(:partial => 'shared/pages', :locals => {:pages => range})
    end
  end

  def range_pages(total)
    per_page = 10
    max = total / per_page 
    ost = total % per_page 
    max += 1 if ost >= 0

    (1..max)
  end

  def author_main_photo(author)
    if author.main_photo
      image_tag(file_url(author.main_photo.thumbs['small']), :width => "88", :height => "119")
    else
      ''
    end
  end

  def file_url(doc)
    db = FileStore.database.name
    "http://93.94.152.87:3000/#{db}/#{doc['doc_id']}/#{doc['file_name']}"
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
      html << content_tag(:i, "> #{cont}".html_safe)
    end

    if path[:author]
      cont = path[:author]
      cont << ' > ' if  path[:album]
      html << content_tag(:i, "#{cont}".html_safe)
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
