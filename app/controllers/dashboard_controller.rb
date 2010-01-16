class DashboardController < ApplicationController
  layout 'dashboard'

  def index 
    @index = true
    @myitems = current_user.items.paginate(:all, :include => :product, :per_page => Item::PAGINATED_AMOUNT, :page => params[:page])
  end
  
  def search
    @search = true
    @query = Product.find_by_sql 'SELECT * FROM products ORDER BY id DESC LIMIT 500'
    @products = Product.paginate(@query, :per_page => Item::PAGINATED_AMOUNT, :page => params[:page])
  end
  
  def deals
    @deals = true
  end

end
