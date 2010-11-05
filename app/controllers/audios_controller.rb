class AudiosController < ApplicationController
  free_actions :index, :search, :album, :author, :year, :show, :bhagavatam

  def index
    @audios  = Audio.paginate(:get_all, :page => params[:page])
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

  def bhagavatam
    @books = SbAlbum.get_all

    unless params[:book_num].blank?
      @album = @books.find{|b| b.book_num == params[:book_num]}
    end

    @album ||= @books.first
    @tracks = @album.get_tracks

    unless params[:track_id].blank?
      @current_track = @tracks.find{|track| track.id == params[:track_id]}
    end
    @current_track ||= @tracks.first

    render :album
  end

  def show
    track = Audio.get_doc!(params[:id])
    path =
      if book = track.from_bhagavatam
        audios_bhagavatam_track_path(book.book_num, track.id)
      elsif (albums = track.get_albums).any?
        album_track_path(albums.first.id, track.id)
      else
        year = track.record_date.year
        author_year_audio_path(track.author.id, year, track.id)
      end

    redirect_to(path)
  end

  def block_title 
    'Лекции'
  end
  helper_method :block_title 


end
