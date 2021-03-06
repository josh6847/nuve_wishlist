module DashboardHelper
  
  def search_product(product, has_product=false)
    %^
      <div class="post-title"><strong>#{product.name}</strong></div>
      <div class="post-details">
      	UPC: #{product.upc} 
      	<span class="post-details">
      	  #{add_to_link(product.id,has_product)}
      	</span>
      </div>
    ^
  end
  def add_to_link(product_id, has_product=false)
    if has_product
      content_tag :span, 'On wish list', :class => 'wishlist_link'
    else
      link_to_remote 'Add to Wishlist', :url => {
  	          :controller => 'items', 
  	          :action => 'create', 
  	          :wishlist_id => current_user.wishlists.first.id,
  	          :product_id => product_id}, 
  	        :html => {:class => 'wishlist_link'}
    end
  end
  
  def list_item(item)
    %^
      <div class="post-title"><strong>#{item.product.name}</strong></div>
    	<div class="post-details">
    		UPC: #{item.product.upc}
    		<span class="post-details" style="display:inline">
    			#{link_to_remote 'Remove', :url => {
    			        :controller => 'wishlists', 
    			        :action => 'destroy_item', 
    			        :id => item.id,
    			        :page => params[:page]},
    			      :confirm => "Are you sure you'd like to remove #{item.product.name}?", 
    			      :html => {:class => 'wishlist_link'}
    			  }
    		</span>
    	</div>
  	^
  end
  
end
