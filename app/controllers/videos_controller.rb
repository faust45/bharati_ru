class VideosController < ApplicationController
  free_actions :index, :author, :show, :year

  def index
    @videos = Video.paginate(:get_all, :page => params[:page])
  end

  def author
    @author = Author.get_doc!(params[:author_id])
    @videos = @author.get_videos

    @years = @author.get_years_with_videos_count
    @years.delete(nil)
  end

  def year
    @year = params[:year]
    @author = Author.get_doc!(params[:author_id])
    @videos = @author.get_videos_by_year(@year) if @year
    if params[:id]
      @video = @videos.find{|v| v.id == params[:id] }
    end

    @video ||= @videos.first

    render :show
  end

  def show
    @video = Video.get_doc!(params[:id])
    @author = @video.author
    @year = @video.record_date.to_date.year
    @videos = @author.get_videos_by_year(@year) if @year
  end

  def acharya
    @acharya ||= Author.get_acharya
  end
  helper_method :acharya

  def authors
    @authors ||= Author.get_math_authors
  end
  helper_method :authors

  def block_title 
    'Видео'
  end
  helper_method :block_title 
end
