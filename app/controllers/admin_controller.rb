class AdminController < ApplicationController
  layout 'admin'
  before_filter :admin_only

  protected
    def admin_only
    end
end
