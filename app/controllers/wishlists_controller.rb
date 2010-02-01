class WishlistsController < ApplicationController
  layout 'dashboard'
  def index
    @index = true
    @wishlists = current_user.wishlists
  end
  
  def show
    @wishlist = current_user.wishlists.find params[:id]
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
end
