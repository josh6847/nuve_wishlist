class Wishlist < ActiveRecord::Base
  belongs_to :user
  belongs_to :item
  
  validates_uniqueness_of :item_id
end
