module Admin::ContentHelper

  def to_dom_id(str)
    str.gsub(/[\.\s]/, '_')
  end

  def attached_file
    unless content.new?
      content_tag(:div, :id => 'attachments') do
        content.attachments.map do |file|
          content_tag(:div, :id => "attachment_#{to_dom_id(file)}") do
            link_to(file, content.attachment_url(file)) + '&nbsp;&nbsp;'.html_safe +
            link_to('del', admin_contents_delete_file_path(content.id, :attach => file), :remote => true)
          end
        end.join('</br>').html_safe
      end
    end
  end

  def mark_by_tags
    content_tag(:div, :id => 'all_tags') do
      content.tags.map {|tag| render_tag(tag) }.join
    end
  end

  def bind_to_co_authors
    content_tag(:div, :id => 'all_co_authors') do
      content.co_authors.map {|co_author| render_co_author(co_author) }.join
    end
  end

  def render_tag(tag)
    content_tag(:label, :id => "label_for_tag_#{to_dom_id(tag)}", :onclick => '$(this).remove()') do
      check_box_tag("#{object_name}[tags][]", tag, true) + tag
    end
  end

  def render_co_author(co_author)
    content_tag(:label, :id => label_id_for(co_author, :co), :onclick => '$(this).remove()') do
      check_box_tag("#{object_name}[co_author][]", co_author.id, {:checked => true}) + co_author.name
    end
  end

  def label_id_for(item, prefix = nil)
    "label_for_#{dom_id(item, prefix)}"
  end

end
