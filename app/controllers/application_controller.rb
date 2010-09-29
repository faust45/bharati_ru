class ApplicationController < ActionController::Base
  layout 'app'

  #include NoficationSystem 

  use_zero_auth

  protect_from_forgery

  #rescue_from User::AccessDenied, :with => :page_404
  #rescue_from ActionView::MissingTemplate, :with => :page_404

  class <<self
  end

  def logger
    Rails.logger
  end

  def page_404
    render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
  end

end
