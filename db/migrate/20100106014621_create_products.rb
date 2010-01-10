class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.text      :tags
      t.string    :name
      t.string    :upc
      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
