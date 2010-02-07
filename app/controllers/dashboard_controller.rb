class DashboardController < ApplicationController
  layout 'dashboard'
  before_filter :search, :only => [:update_search]
  before_filter :index, :only => [:update_index]
  before_filter :authorize_edit, :only => [:destroy_list]

  def index 
    @index = true
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
    @user_product_ids = current_user.items(:include => :wishlist).collect(&:product_id) #wishlists get cached
    @wishlists = current_user.wishlists
    if params[:query].blank?
      @products = Product.paginate(:page => params[:page], :per_page => Product::PAGINATED_AMOUNT)
    else
      @products = Product.all(:conditions => ["products.name REGEXP ?", params[:query]], :limit => 700)
      @product_count = @products.size
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
  
  def destroy_list
    @wishlist.destroy
    @wishlist = false
    render :update do |page|
      page.redirect_to :action => "search"
    end
    #render :update do |page|
    #  page.replace_html "wishlist_sidebar", 
    #      :partial => 'wishlists/side_menu'
    #  #page << %^
    #  #  $j('#side_menu_list_#{params[:id]}').hide(200);
    #  #  $j('#side_menu_list_#{params[:id]}').remove();
    #  #^
    #end
  end
  protected
    def authorize_edit
      @wishlist = current_user.wishlists.find(params[:id])
      unless @wishlist
        redirect_to(search_path)
        return false
      end
    end
  
end
