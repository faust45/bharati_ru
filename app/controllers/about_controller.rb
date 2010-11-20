class AboutController < ApplicationController
  free_actions :index, :author

  def index
    @about = About[params[:about]] || About.bharati_ru
  end

  def author
    if params[:id]
      @author = authors.find{|a| a.id ==  params[:id]}
    end

    @author ||= @authors.first
  end

  def authors
    @authors ||= Author.get_math_authors
  end
  helper_method :authors

end
