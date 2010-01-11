class Item < ActiveRecord::Base
  PAGINATED_AMOUNT = 7
  belongs_to :wishlist
  belongs_to :product
  
  validates_uniqueness_of 'product_id', :scope => 'wishlist_id'
  
end
