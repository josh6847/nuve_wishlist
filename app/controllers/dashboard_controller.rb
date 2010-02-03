class DashboardController < ApplicationController
  layout 'dashboard'
  before_filter :search, :only => [:update_search]
  before_filter :index, :only => [:update_index]

  def index 
    @index = true
  #  @page = params[:page].blank? ? 1 : params[:page].to_i
    @myitems = current_user.items(:include => :product).paginate( :per_page => Item::PAGINATED_AMOUNT, :page => params[:page])
  end
  
  def update_index
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html "user_#{current_user.id}_wishlist", :partial => 'wishlist'
        end # render
      end # format
    end # respond_to
  end
  
  def search
    @search = true
    if params[:query].blank?
      @products = Product.paginate(:page => params[:page], :per_page => Product::PAGINATED_AMOUNT)
    else
      @products = Product.all(:conditions => ["products.name REGEXP ?", params[:query]])
      @product_count = @products.count
      @products = @products.paginate(:page => params[:page], :per_page => Product::PAGINATED_AMOUNT)
    end
  end
  
  def update_search
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html 'products', :partial => 'results'
        end # render
      end # format
    end # respond_to
  end
  
  def deals
    @deals = true
  end

end
