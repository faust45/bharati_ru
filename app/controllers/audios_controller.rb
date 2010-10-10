class AudiosController < ApplicationController
  free_actions :index, :album, :author, :year, :show

  def index
    @audios  = Audio.order_by_created_at
    @acharya = Author.get_acharya
    @authors = Author.get_authors
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
    @albums = @current_author.albums
    @last_tracks = @author.last_tracks 

    @years = @author.years_with_tracks
    
    #@last = Audio.get_by_author(self.id)
  end

  def year
    @year = params[:year]
    @author = Author.get_doc!(params[:author_id])

    unless @year.blank?
      @tracks = @author.tracks_by_year(@year)
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
    albums = track.albums
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
