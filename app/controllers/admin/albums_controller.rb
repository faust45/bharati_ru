class Admin::AlbumsController < Admin::ContentsController
  protect_from_forgery :except => :destroy
  helper Admin::AlbumsHelper

  def index
    @albums = Album.all
  end

  def new
    @album = Album.new
  end

  def create
    @album = Album.new(params[:album])
    @album.save

    flash[:notice] = 'Album created success!'
    redirect_to admin_albums_path
  end

  def edit
  end

  def update
    album.update_attributes(params[:album])
    redirect_to admin_albums_path
  end

  def destroy
    album.destroy
    redirect_to admin_albums_path
  end

  def album
    @album ||= Album.get(params[:id])
  end

  def autocomplete
    albums = Album.search(params[:q])
    albums.map!{|t| "#{t['fields']['default']}|#{t['id']}"}

    render :json => albums.join("\n").to_json
  end

  helper_method :album

  def add_track
    audio = Audio.get!(params[:track_id])
    album << audio

    render :json => 'ok'
  end

  def del_track
    audio = Audio.get!(params[:track_id])
    album >> audio

    render :json => 'ok'
  end

end
