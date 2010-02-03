class ItemsController < ApplicationController
  layout 'dashboard'
  
  def index
    redirect_to home_path
  end
  
  def create
    @wishlist = current_user.wishlists.find(params[:wishlist_id])
    @product  = Product.find(params[:product_id])
    @item = @wishlist.items.build(:wishlist_id => @wishlist.id, :product_id => @product.id)
    if @wishlist && @product && @item.save
      render :update do |page|
        page.replace_html "search_product_#{@product.id}", :partial => 'dashboard/search_product', :locals => {:product => @product}
        page << "$j('#search_product_#{@product.id}').addClass('owned');"
      end
    else
      render :nothing => true
    end
  end
  
  def destroy
    item = current_user.items.find(params[:id])
    wishlist_id = item.wishlist_id
    item.destroy
    current_user.reload
    page = params[:page].to_i
    params[:page] = page-1 if page != 1 && current_user.items.count <= ((page-1)*Item::PAGINATED_AMOUNT)
    items = current_user.items(:include => :product).paginate(:per_page => Item::PAGINATED_AMOUNT, :page => params[:page])
    render_update "wishlist_#{wishlist_id}", 
          :partial => 'dashboard/wishlist', 
          :locals => {
            :items => items}
  end
  
end
