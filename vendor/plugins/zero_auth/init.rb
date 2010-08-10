require File.dirname(__FILE__) + '/lib/zero_auth.rb'

class ActionController::Base

  def self.use_zero_auth
    include ZeroAuth::ControllerExtensions
  end

end
