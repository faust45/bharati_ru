module TeachersHelper

  def teacher_photo(teacher)
    photo_thumb(teacher.main_photo_page_menu, {:width => "117", :height => "183"}, true)
  end

end
