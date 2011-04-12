class TeachersController < ApplicationController
  free_actions :index, :preachers

  def index
    @teachers = Author.get_teachers
    teacher

    @page_title = ["Учители", "#{@teacher}"]
  end

  def preachers 
    @teachers = Author.get_math_authors
    teacher

    @page_title = ["Проповедники", "#{@teacher}"]
  end

  def teacher
    if params[:id]
      @teacher = Author.get_doc(params[:id])
    end

    @teacher ||= @teachers.first
    @page_description = @teacher.bio.first(500)
  end

end
