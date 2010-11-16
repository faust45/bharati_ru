module TeachersHelper
  def name(teacher)
    "<span>#{teacher.display_name}</span>".html_safe
  end

  def teacher_li(teacher)
    photo = photo_thumb(teacher.main_photo_page_menu, {:width => "117", :height => "183"}, true) + name(teacher)

    if @teacher == teacher
      content_tag(:strong, photo)
    else
      link_to photo, teacher_show_path(teacher.id)
    end
  end
end
