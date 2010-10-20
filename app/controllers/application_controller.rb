class ApplicationController < ActionController::Base
  layout 'app'

  #include NoficationSystem 

  use_zero_auth

  protect_from_forgery

  if Rails.env.production?
    rescue_from User::AccessDenied, :with => :page_404
    rescue_from ActionView::MissingTemplate, :with => :page_404
    rescue_from ActionView::Template::Error, :with => :page_404
  end

  class <<self
  end

  def logger
    Rails.logger
  end

  def page_404
    render :template => "shared/404.html.erb", :status => 404
  end

end
