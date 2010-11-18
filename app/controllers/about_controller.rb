class AboutController < ApplicationController
  free_actions :index

  def index
    @authors = Author.get_authors
    if params[:id]
      @author = Author.get_doc(params[:id])
    end

    @author ||= @authors.first
  end

end
