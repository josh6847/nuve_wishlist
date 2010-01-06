class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :upc
      t.string :name,               :null => false
      t.string :description
      t.string :tags
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end