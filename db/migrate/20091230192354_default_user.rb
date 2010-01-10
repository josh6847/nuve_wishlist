class DefaultUser < ActiveRecord::Migration
  def self.up
    user = User.new :first_name => 'root', :last_name => 'user', :email => 'admin@lanuve.com'
    user.login = 'root'
    user.phone='1234567890'
    user.password = 'nuve4Udude'
    user.password_confirmation = 'nuve4Udude'
    user.verified = true
    user.save
  end

  def self.down
    User.find_by_login('root').destroy
  end
end
