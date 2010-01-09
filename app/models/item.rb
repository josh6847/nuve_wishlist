class Item < ActiveRecord::Base
  has_many :wishlists
  has_one :product, :dependent => :destroy
end
