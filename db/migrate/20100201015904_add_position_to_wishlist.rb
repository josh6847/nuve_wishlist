class AddPositionToWishlist < ActiveRecord::Migration
  def self.up
    add_column :wishlists, :position, :integer
    add_index :wishlists, :position
  end

  def self.down
  end
end
