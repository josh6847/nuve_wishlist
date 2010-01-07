class ItemsController < ApplicationController
  layout 'dashboard'
  
  def index
  end

  def add
    @item = Item.find(params[:id])
    current_user.items << @item
    flash[:notice] = "That item was added."
    redirect_to :back
  end
  
  def destroy
    @item = Wishlist.find(:first, :conditions => {:item_id => params[:id]})
    @item.destroy
    flash[:notice] = "That item was removed."
    redirect_to :back
  end

end
