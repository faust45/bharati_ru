class ForumController < ApplicationController
  layout 'forum'
  before_filter :assign_section

  def index
  end

  def assign_section
    Forum.set_section(params[:section])
  end

end
