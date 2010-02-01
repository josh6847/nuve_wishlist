class WishlistsController < ApplicationController
  layout 'dashboard'
  before_filter 'show', :only => [:update_wishlist]
  def index
    @index = true
    @wishlists = current_user.wishlists
  end
  
  def show
    @wishlist ||= current_user.wishlists.find params[:id]
    @myitems = @wishlist.items(:include => :product).paginate( :per_page => Item::PAGINATED_AMOUNT, :page => params[:page])
  end
  
  def update_wishlist
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html "show_wishlist", :partial => 'show'
        end # render
      end # format
    end # respond_to
  end
  
  def create
    @wishlist = current_user.wishlists.build params[:wishlist]
    if @wishlist.save
      render :update do |page|
        page.insert_html :bottom, :wishlists_side, :partial => "li_side_menu", :locals => {:list => @wishlist}
        page.insert_html :bottom, :wishlists_main, :partial => "li_main", :locals => {:list => @wishlist}
        page << %^
          $j('#new_wishlist_form').hide();
          $j('#cancel_new_wishlist').hide();
          $j('#new_wishlist_button').show();
          $j('#wishlist_error').html('');
          $j('#wishlist_count').html('#{current_user.wishlist_heading}');
        ^
      end
    else
      render :update do |page|
#        page << "$j('#')"
        page << %^$j('#wishlist_error').html('A wishlist must have a name')^
      end
    end
  end
  
  def destroy_item
    item = current_user.items.find(params[:id])
    @wishlist = item.wishlist
    item.destroy
    @wishlist.reload
    show
    page = params[:page].to_i
    params[:page] = page-1 if page != 1 && @wishlist.items.count <= ((page-1)*Item::PAGINATED_AMOUNT)
    
    render :update do |page|
      page.replace_html "show_wishlist", :partial => 'show'
    end
#    render_update "wishlist_#{@wishlist.id}", :action => 'show'
  end
end
