class Wishlist < ActiveRecord::Base
  belongs_to :user
  has_many :items, :dependent => :destroy
  validates_presence_of :name
  before_create :set_position
  
  def set_position
    self.position = Wishlist.all(:conditions => {:user_id => self.user_id}).size + 1
  end
  
end
