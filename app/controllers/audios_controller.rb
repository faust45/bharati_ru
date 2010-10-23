class AudiosController < ApplicationController
  free_actions :index, :search, :album, :author, :year, :show

  def index
    @audios  = Audio.get_all
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
    @author = Author.get_doc!(params[:author_id])
    @albums = @author.get_albums
    @last_tracks = @author.paginate(:get_tracks, :page => params[:page])

    @years = @author.get_years_with_tracks_count
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
