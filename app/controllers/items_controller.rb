class ItemsController < ApplicationController
  layout 'dashboard'
  
  def index
    redirect_index
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
      redirect_to :controller => 'dashboard', :action => 'search'
    else
      flash[:notice] = "Invalid option."
      redirect_index
    end
  end
  
  def destroy
    @wishlist_item = Wishlist.find(:first, :conditions => {:item_id => params[:id], :user_id => current_user.id}) rescue nil
    unless @wishlist_item.nil?
      @wishlist_item.destroy 
      flash[:notice] = "That item was removed."
      redirect_to :controller => 'dashboard'
    else
      flash[:notice] = "Invalid option."
      redirect_index
    end
  end
  
  def method_missing *args
    redirect_index
  end
  
  protected
  
  def redirect_index
    redirect_to :controller => 'dashboard'
  end

end
