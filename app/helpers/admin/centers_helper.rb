module Admin::CentersHelper
  def photos 
    unless center.new?
      content_tag(:div, :id => 'attachments') do
        center.attachments.map do |file|
          content_tag(:div, :id => "attachment_#{to_dom_id(file)}") do
            link_to(file, center.attachment_url(file)) + '&nbsp;&nbsp;'.html_safe +
            link_to_del(admin_centers_delete_file_path(center.id, :attach => file), :remote => true)
          end
        end.join('</br>').html_safe
      end
    end
  end
end
