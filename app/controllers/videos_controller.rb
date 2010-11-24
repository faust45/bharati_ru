class VideosController < ApplicationController
  free_actions :index, :author, :show

  def index
    @videos  = Video.paginate(:get_all, :page => params[:page])
    @acharya = Author.get_acharya
    @authors = Author.get_math_authors
  end

  def author

  end

  def show
    @video = Video.get_doc!(params[:id])
  end

  def block_title 
    'Видео'
  end
  helper_method :block_title 
end
