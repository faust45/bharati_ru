class TeachersController < ApplicationController
  free_actions :index

  def index
    @teachers = Author.get_teachers
    if params[:id]
      @teacher = Author.get_doc(params[:id])
    end

    @teacher ||= @teachers.first
  end

end
