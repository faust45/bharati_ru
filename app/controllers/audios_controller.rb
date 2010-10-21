class AudiosController < ApplicationController
  free_actions :index, :search, :album, :author, :year, :show

  def index
    @per_page = 10
    @page = (params[:page] || 1).to_i

    @audios  = Audio.get_all(:limit => 10, :skip => @page * @per_page)
    @acharya = Author.get_acharya
    @authors = Author.get_authors
    @total_pages = Audio.count
  end

  def album
    @album  = Album.get_doc!(params[:album_id])
    @tracks = @album.get_tracks
    if params[:id]
      @current_track = @tracks.find{|el| el.id == params[:id]} 
    else
      @current_track = @tracks.first
    end
    @author = @album.author
  end

  def author
    @acharya = Author.get_acharya
    @authors = Author.get_authors
    @current_author = Author.get_doc!(params[:author_id])
    @author = @current_author
    @albums = @current_author.get_albums
    @last_tracks = @author.get_tracks 

    @years = @author.get_years_with_tracks_count
    
    #@last = Audio.get_by_author(self.id)
  end

  def year
    @year = params[:year]
    @author = Author.get_doc!(params[:author_id])

    unless @year.blank?
      @tracks = @author.get_tracks_by_year(@year)
      if params[:id]
        @current_track = Audio.get_doc!(params[:id])
      else
        @current_track = @tracks.first
      end
    end

    render :album
  end

  def show
    track = Audio.get_doc!(params[:id])
    albums = track.get_albums
    path =
    if albums.any?
      album_track_path(albums.first.id, track.id)
    else
      year = track.record_date.year
      author_year_audio_path(track.author.id, year, track.id)
    end

    redirect_to(path)
  end

end
