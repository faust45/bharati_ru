module TeachersHelper
  def name(teacher)
    "<span>#{teacher.display_name}</span>".html_safe
  end
end
