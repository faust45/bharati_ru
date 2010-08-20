class AudiosController < ApplicationController
  free_actions :index, :show
  skip_before_filter :verify_authenticity_token

  def index
    @audios = Audio.all
  end

  def show 
    @audio = Audio.get(params[:id])
    @album = @audio.albums.first

    @bookmarks = current_user.bookmarks_for(@audio) 
    @author_bookmarks = [
      ['This is introduction', 69000 * 60],
      ['Chapter 1 - I talk about Krishna', 90000],
      ['Chapter 2 - I talk about Radharani', 10000],
    ].map{ |el|
      HHash.new(:title => el.first, :time => el.last)
    }

    @shared_bookmarks = @audio.shared_bookmarks
  end

end
