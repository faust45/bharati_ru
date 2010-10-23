class SearchController < ApplicationController
  free_actions :all

  def audios
    @authors = Author.get_acharya + Author.get_authors
    @audios = Audio.search(params[:q], params)
  end

end
