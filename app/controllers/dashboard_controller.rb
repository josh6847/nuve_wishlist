class DashboardController < ApplicationController
  layout 'dashboard'
  before_filter :session_expiry, :login_required, :is_verified?

  def index 
    @index = true
  end

  #def wishlist
  #  @wishlist = true
  #end
  
  def search
    @search = true
  end
  
  def deals
    @deals = true
  end
  
  def method_missing(*args)
    debugger
    redirect_to :action => 'index' unless action_name == 'index'
  end
  
  #def redirect
  #  redirect_to :action => 'wishlist'
  #end

end
