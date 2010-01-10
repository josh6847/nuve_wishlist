require 'csv-mapper'
include CsvMapper

class Item < ActiveRecord::Base
  
  has_many :wishlists
  has_one :product, :dependent => :destroy
  
  def self.pop_items
    p "Beginning processing CSV file"
    start = Time.now
    results = import("tmp/items.csv") do
      start_at_row 1
      [upc, weight, description]
    end
    proc_done = Time.now
    p "Processing CSV file took #{(proc_done-start).minutes}"
    results.each_with_index do |result,i|
      Item.create :upc => result.upc, :name => result.description
      p "Added 1000 items" if i%1000 == 0
    end
  end
  
  def self.pop_dummy_data
    require 'nokogiri'
    require 'open-uri'
    begin
      page = Nokogiri::HTML(open('http://www.oracle.com/products/product_list.html'))
      page.css('td.innerBoxContent').each do |td|
        td.css('ul li').each do |li|
          content = li.css('a').first.content rescue ""
          unless content.blank?
            @item = Item.create(:upc => 999, :name => content, :description => 'Enterprise Stuff')
            Product.create(:item_id => @item.id, :location_id => 1, :category => 'Enterprise Stuff', :price => 345)
          end
        end
      end
    rescue
      # do nothing
    end
  end
  
end
