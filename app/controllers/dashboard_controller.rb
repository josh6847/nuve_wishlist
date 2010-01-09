class DashboardController < ApplicationController
  layout 'dashboard'

  def index 
    @index = true
    @myitems = current_user.items.paginate(:all, :include => :product, :per_page => 7, :page => params[:page])
  end
  
  def search
    @search = true
    @items = Item.paginate(:all, :include => :product, :per_page => 7, :page => params[:page])
  end
  
  def deals
    @deals = true
  end
  
  def method_missing(*args)
    redirect_to :action => 'index' unless action_name == 'index'
  end

end
