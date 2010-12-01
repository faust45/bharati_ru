module ApplicationHelper
  RU_MONTH = %w(январь февраль март апрель май июнь июль август сентябрь октябрь ноябрь декабрь) 

  def t(text)
    unless text.blank?
      text = text.sub(/^/, '&nbsp;' * 5)
      text.gsub!(/\n/, '<br />' + '&nbsp;' * 5)
      text.gsub!(/(http.+?)\s*\[(.*?)\]/) do
        link_to($2, $1, :target => '_blank')
      end

      raw text
    end
  end

  def short_t(text)
    unless text.blank?
      text.gsub!(/\n/, '<br />')
      text.gsub!(/(http.+?)\s*\[(.*?)\]/) do
        link_to($2, $1, :target => '_blank')
      end

      raw text
    end
  end

  def main_path(&block)
    PagePath.new(self, &block)
  end

  def is_selected_author?(author_item)
    @author == author_item
  end

  def search_path

  end

  def year_folder
    image_tag('/images/year_folder.png', :class => 'year-folder')
  end

  def menu_glance(options = {}, &block)
    MenuGlance.new(self, options, &block).to_s
  end

  def slink_to(photo, text, href, options = {})
    text = content_tag(:span, text.html_safe)
    link_to photo + text, href, options
  end

  def ru_month(month)
   RU_MONTH[month.to_i - 1]
  end

  def author_display_name(content)
    Author.display_name_by_id(content.author_id)
  end

  def author_path(author)
    author_publications_path(author)
  end

  def author_main_photo(author)
    if author.main_photo
      photo_thumb(author.main_photo, {:width => 88, :height => 119}, true)
    else
      ''
    end
  end

  def author_inner_photo(author)
    if author.main_photo_inner
      photo_thumb(author.main_photo_inner, {:width => 281, :height => 202}, true)
    else
      ''
    end
  end


  def photo_thumb(img_id, size, round = false) 
    p = "http://93.94.152.87:81/#{img_id}?size=#{size[:height]}x#{size[:width]}"
    p << "&round=1" if round
    image_tag(p)
  end

  def hit_tags(item)
    cont = h(item.tags)
    unless cont.blank?
      "<p>Теги:&nbsp;&nbsp;#{cont}</p>".html_safe
    end
  end

  def hit_bookmarks(item)
    cont = h(item.bookmarks.map{|a| a['name']}, 0)
    unless cont.blank?
      "<p>Закладки:&nbsp;&nbsp;#{cont}</p>".html_safe
    end
  end

  def h(obj, max_out = 2)
    obj = obj.highlight(params[:q])

    if obj.is_a?(Array)
      if i = obj.index{|item| item.is_highlight?}
        left = i - max_out
        right = i + max_out
        obj[left..right].join(',&nbsp;').html_safe
      end
    else
      obj.html_safe
    end
  end

  def site_ppath
    SitePath.new(params, self)
  end

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

  
  def file_url(doc)
    db = FileStore.database.name
    "http://93.94.152.87/#{db}/#{doc['doc_id']}/#{doc['file_name']}"
  end

  def dy(date)
    d(date, 'года')
  end

  def d(date, prefix = nil)
    unless date.blank?
      date = l(date.to_date, :format => :long) 

      if prefix
        date += '&nbsp;' + prefix
      end

      raw date
    end

  rescue ArgumentError, TypeError => ex
    nil
  end

  def dt(date, time)
    res = d(date)
    res << " в #{time}" unless time.blank?

    res
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

  def content(&block)
    content_for(:content, block)
  end

  def p_sidebar(template)
    content_for(:sidebar) do
      render :partial => template
    end
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
