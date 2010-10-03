class AudiosController < ApplicationController
  free_actions :index, :album, :author
  skip_before_filter :verify_authenticity_token

  def index
    @audios  = Audio.order_by_created_at
    @acharya = Author.get_acharya
    @authors = Author.get_authors
  end

  def album
    @album  = Album.get(params[:album_id])
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
    @current_author = Author.get(params[:author_id])
    @albums = @current_author.albums
    #@last = Audio.get_by_author(self.id)
  end

end
