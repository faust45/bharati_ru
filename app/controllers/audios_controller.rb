class AudiosController < ApplicationController
  free_actions :index, :album
  skip_before_filter :verify_authenticity_token

  def index
    @audios = Audio.all
  end

  def album
    @album = Album.first
    @audio = Audio.get('83145')
    #@album = Album.get(params[:album_id])
    #@tracks = @album.tracks
    #@album_author = @album.author
  end

end
