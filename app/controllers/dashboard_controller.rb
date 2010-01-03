class DashboardController < ApplicationController
  layout 'dashboard'
  before_filter :session_expiry, :login_required, :is_verified?

  def index 
    redirect
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
    redirect
  end
  
  def redirect
    redirect_to :action => 'wishlist'
  end

end
