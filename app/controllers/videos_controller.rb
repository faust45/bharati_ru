class VideosController < ApplicationController
  free_actions :index, :author, :show, :year

  def index
    @videos = Video.paginate(:get_all, :page => params[:page])
    @page_title = "Видео"
  end

  def author
    @author = Author.get_doc!(params[:author_id])
    @videos = @author.paginate(:get_videos, :page => params[:page])

    @years = @author.get_years_with_videos_count
    @years.delete(nil)

    @page_title = ["Видео", @author.to_s]
  end

  def year
    @year = params[:year]
    @author = Author.get_doc!(params[:author_id])
    @videos = @author.get_videos_by_year(@year) if @year
    if params[:id]
      @video = @videos.find{|v| v.id == params[:id] }
    end

    @video ||= @videos.first

    @page_title = ["Видео", @author.to_s, @year.to_s]
    render :show
  end

  def show
    @video = Video.get_doc!(params[:id])
    @author = @video.author
    @year = @video.record_date.to_date.year
    @videos = @author.get_videos_by_year(@year) if @year

    @page_title = ["Видео", @author.to_s, @year.to_s, @video.to_s]
  end

  def acharya
    @acharya ||= Author.get_acharya
  end
  helper_method :acharya

  def authors
    @authors ||= Author.get_math_authors.reject{|a| ['SiddhantiMj', 'SrutasravaPr', 'GoswamiMj'].include?(a.id) }
  end
  helper_method :authors

  def block_title 
    'Видео'
  end
  helper_method :block_title 
end
