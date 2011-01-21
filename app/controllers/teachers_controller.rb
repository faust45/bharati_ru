class TeachersController < ApplicationController
  free_actions :index, :preachers

  def index
    @teachers = Author.get_teachers
    teacher
  end

  def preachers 
    @teachers = Author.get_math_authors
    teacher
  end

  def teacher
    if params[:id]
      @teacher = Author.get_doc(params[:id])
    end

    @teacher ||= @teachers.first
  end

end
