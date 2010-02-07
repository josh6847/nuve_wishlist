class WishlistsController < ApplicationController
  layout 'dashboard'
  before_filter 'set_index'
  before_filter 'show', :only => [:update_wishlist]
  before_filter 'authorize_edit', :only => [:update, :destroy_list]
  def index
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
  
  def create    #GOOD TO GO
    list = current_user.wishlists.build params[:wishlist]
    if list.save
      current_user.reload
      @wishlist = current_user.wishlists.find params[:wishlist_id] rescue false
      render :update do |page|
        if params[:prev_controller] == 'dashboard'
          page.redirect_to :controller => params[:prev_controller], :action => params[:prev_action]
        else
          page.insert_html :bottom, :wishlists_side, :partial => "li_side_menu", :locals => {:list => list}
          page.insert_html :bottom, :wishlists_main, :partial => "li_main", :locals => {:list => list} if 
              params[:prev_controller] == "wishlists" && params[:prev_action] == "index"
          page << %^
            $j('#new_wishlist_form').hide(300);
            $j('#cancel_new_wishlist').hide();
            $j('#new_wishlist_button').show();
            $j('#wishlist_error').html('');
            $j('#wishlist_count').html('#{current_user.wishlist_heading}');
          ^
        end
      end
    else
      render :update do |page|
        page << %^$j('#wishlist_error').html('A wishlist must have a name')^
      end
    end
  end
  
  def update
    
  end
  
  def destroy_list
    @wishlist.destroy
    current_user.reload
    @wishlist = current_user.wishlists.find(params[:wishlist_id]) rescue false
    render :update do |page|
      if params[:id] == params[:wishlist_id] || params[:prev_action] == 'index'
        page.redirect_to :action => "index"
      else
        params[:action] = params[:prev_action]
        page.replace_html "wishlist_sidebar", 
            :partial => 'wishlists/side_menu'
        #page << %^
        #  $j('#side_menu_list_#{params[:id]}').hide(200);
        #  $j('#side_menu_list_#{params[:id]}').remove();
        #^
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
  end
  protected
    def set_index
      @index = true
    end
    
    def authorize
    end
    
    def authorize_edit
      @wishlist = current_user.wishlists.find(params[:id])
      unless @wishlist
        redirect_to(home_path)
        return false
      end
    end
end
