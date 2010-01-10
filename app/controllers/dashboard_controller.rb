class DashboardController < ApplicationController
  layout 'dashboard'

  def index 
    @index = true
    @myitems = current_user.items.paginate(:all, :include => :product, :per_page => Item::PAGINATED_AMOUNT, :page => params[:page])
  end
  
  def search
    @search = true
    @products = Product.paginate(:all, :per_page => Item::PAGINATED_AMOUNT, :page => params[:page])
  end
  
  def deals
    @deals = true
  end

end
