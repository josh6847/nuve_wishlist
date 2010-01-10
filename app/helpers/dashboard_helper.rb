module DashboardHelper
  
  def search_product(product)
    %^
      <div class="post-title"><strong>#{product.name}</strong></div>
      <div class="post-details">
      	UPC: #{product.upc} 
      	<span class="post-details">
      	  #{add_to_link(product.id)}
      	</span>
      </div>
    ^
  end
  def add_to_link product_id
    if current_user.has_product? product_id
      %^
        <span class="wishlist-link">
          On wish list
        </span
      ^
    else
      link_to_remote 'Add to Wishlist', :url => {
  	          :controller => 'items', 
  	          :action => 'create', 
  	          :wishlist_id => current_user.wishlists.first.id,
  	          :product_id => product_id}, 
  	        :html => {:class => 'wishlist-link'}
    end
  end
  
  def list_item(item)
    %^
      <div class="post-title"><strong>#{item.product.name}</strong></div>
    	<div class="post-details">
    		UPC: #{item.product.upc}
    		<span class="post-details">
    			#{link_to_remote 'Remove', :url => {
    			        :controller => 'items', 
    			        :action => 'destroy', 
    			        :id => item.id,
    			        :page => params[:page]},
    			      :confirm => "Are you sure you'd like to remove #{item.product.name}?", 
    			      :html => {:class => 'wishlist-link'}
    			  }
    		</span>
    	</div>
  	^
  end
  
end
