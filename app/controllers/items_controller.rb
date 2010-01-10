class ItemsController < ApplicationController
  layout 'dashboard'
  
  def index
    redirect_to :controller => 'dashboard'
  end

  def add
    @item = Item.find(params[:id]) rescue nil
    unless @item.nil?
      @wishlist_item = Wishlist.new :user_id => current_user.id, :item_id => params[:id]
      if @wishlist_item.save
        flash[:notice] = "That item was added."
      else
        flash[:notice] = "You already have this."
      end
      redirect_to :back
    else
      flash[:notice] = "Invalid option."
      index
    end
  end
  
  def destroy
    @wishlist_item = current_user.wishlists.find(:first, :conditions => {:item_id => params[:id]}) rescue nil
    unless @wishlist_item.nil?
      @wishlist_item.destroy 
      flash[:notice] = "That item was removed."
      redirect_to :back
    else
      flash[:notice] = "Invalid option."
      index
    end
  end
  
  def method_missing *args
    index
  end

end
