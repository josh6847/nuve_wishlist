class DashboardController < ApplicationController
  layout 'dashboard'

  def index 
    @index = true
    debugger
    @myitems = @current_user.items
  end
  
  def search
    @search = true
    debugger
    @items = Item.find(:all, :include => :product)
  end
  
  def deals
    @deals = true
  end
  
  def method_missing(*args)
    redirect_to :action => 'index' unless action_name == 'index'
  end

end
