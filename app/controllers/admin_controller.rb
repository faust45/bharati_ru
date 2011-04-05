class AdminController < ApplicationController
  layout 'admin'
  before_filter :admin_only

  protected
    def admin_only
      raise User::AccessDenided unless current_user.admin?
    end
end
