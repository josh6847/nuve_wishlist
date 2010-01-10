class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.float   :desired_price
      t.text    :description
      t.integer :product_id
      t.integer :wishlist_id
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
