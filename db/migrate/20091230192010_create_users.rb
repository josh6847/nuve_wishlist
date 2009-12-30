class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      t.column :login,                     :string, :limit => 40
      t.string :first_name, :limit => 75, :null => false
      t.string :last_name, :limit => 75, :null => false
      t.column :email,                     :string, :limit => 100
      t.column :phone,                     :string, :limit => 20
      t.column :password_hash,             :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :remember_token,            :string, :limit => 40
      t.column :remember_token_expires_at, :datetime
      t.boolean :verified, :default => false
      t.timestamps
    end
    add_index :users, :login, :unique => true
  end

  def self.down
    drop_table :users
  end
end
