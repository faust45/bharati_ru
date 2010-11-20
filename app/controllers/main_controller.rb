class MainController < ApplicationController
  free_actions :index

  def index
    @acharya = Author.get_acharya
    @audios = Audio.get_all(:limit => 5)
    @publications = Publication.get_all(:limit => 5)
  end

end
