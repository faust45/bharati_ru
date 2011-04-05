class ApplicationController < ActionController::Base
  layout 'app'
  clear_helpers #discard helper :all in ActionController::Base

  #include NoficationSystem 

  use_zero_auth

  #protect_from_forgery

  if Rails.env.production?
    rescue_from User::AccessDenided, :with => :goto_root
    rescue_from ActionView::MissingTemplate, ActionView::Template::Error,
        RestClient::ResourceNotFound, Doc::NotFound,
        :with => :page_404
  end

  free_actions :page_404

  class <<self
  end

  def logger
    Rails.logger
  end

  def page_404
    render :template => "shared/404.html.erb", :status => 404
  end

  def goto_root
    redirect_to root_path
  end

end
