class AddIndexesToModels < ActiveRecord::Migration
  def self.up
    #change_column :items, :description, :text, :limit => 1000
    #Item.reset_column_information
    #
    #change_column :wishlists, :description, :text, :limit => 1000
    #Wishlist.reset_column_information
    #
    #change_column :products, :tags, :text, :limit => 2000
    #Product.reset_column_information
    
    add_index :users, :id             , :unique => true
    
    add_index :products, :upc         , :unique => true
    add_index :products, :name        
    add_index :products, :id          , :unique => true
    
    add_index :items, :id             , :unique => true
    add_index :items, :product_id     
    add_index :items, :wishlist_id    
    #add_index :items, :description    
    
    add_index :wishlists, :user_id    
    add_index :wishlists, :name       
    add_index :wishlists, :active     
    #add_index :wishlists, :description
  end

  def self.down
    remove_index :users, :id
    
    remove_index :products, :upc
    remove_index :products, :name
    remove_index :products, :id
    
    remove_index :items, :id
    remove_index :items, :product_id
    remove_index :items, :wishlist_id
    #remove_index :items, :description
    
    remove_index :wishlists, :user_id
    remove_index :wishlists, :name
    remove_index :wishlists, :active
    #remove_index :wishlists, :description
  end
end
