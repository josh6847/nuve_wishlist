class CreateWishlists < ActiveRecord::Migration
  def self.up
    create_table :wishlists do |t|
      t.string  :name, :nil => false
      t.text    :description
      t.boolean :active
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :wishlists
  end
end
