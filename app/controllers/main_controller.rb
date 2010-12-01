class MainController < ApplicationController
  free_actions :index

  def index
    @acharya = Author.get_acharya
    @audios = Audio.get_all(:limit => 5)
    @publications = Publication.get_all(:limit => 5)
    @videos = Video.get_all(:limit => 5)

    @events = Event.get_main
    @news = Event.get_news.first
    @video = Video.get_main.first
  end

end
