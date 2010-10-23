class SearchController < ApplicationController
  free_actions :audios

  def audios
    @authors = Author.get_acharya + Author.get_authors
    @audios = Audio.search(params[:q], params)
  end

end
