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
    @wishlist_item = Wishlist.find(:first, :conditions => {:item_id => params[:id], :user_id => current_user.id}) rescue nil
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
  
  def run_pop
    pop_dummy_data
  end
  
  protected
  
  def pop_dummy_data
    require 'nokogiri'
    require 'open-uri'
    begin
      page = Nokogiri::HTML(open('http://www.oracle.com/products/product_list.html'))
      page.css('td.innerBoxContent').each do |td|
        td.css('ul li').each do |li|
          content = li.css('a').first.content rescue ""
          unless content.blank?
            @item = Item.create(:upc => 999, :name => content, :description => 'Enterprise Stuff')
            Product.create(:item_id => @item.id, :location_id => 1, :category => 'Enterprise Stuff', :price => 345)
          end
        end
      end
    rescue
      # do nothing
    end
  end

end
