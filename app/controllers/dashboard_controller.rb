class DashboardController < ApplicationController
  layout 'dashboard'
  before_filter :session_expiry, :login_required, :is_verified?

  def index 
    @wishlist = true
    render :action => 'wishlist'
  end

  def wishlist
    @wishlist = true
  end
  
  def search
    @search = true
  end
  
  def deals
    @deals = true
  end
  
  def method_missing(*args)
    @wishlist = true
    render :action => 'wishlist'
  end

end
