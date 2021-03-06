require 'csv'
class Product < ActiveRecord::Base
  PAGINATED_AMOUNT = 25
  has_many :items
  
  validates_uniqueness_of :upc
  serialize :tags, Array
  
  def self.pop_products
    p "Beginning processing CSV file"
    i = 1
    start = Time.now
    CSV.open("tmp/items.csv","r") do |result|
      Product.create :upc => result[0], :name => result[2]
      p "Added #{i} products after #{Time.now-start} seconds" if (i%1000).zero?
      i+=1
    end
    p "Total time was #{(Time.now-start)/60} minutes"
  end
  
  def self.pop_dummy_data
    require 'nokogiri'
    require 'open-uri'
    begin
      page = Nokogiri::HTML(open('http://www.oracle.com/products/product_list.html'))
      page.css('td.innerBoxContent').each do |td|
        td.css('ul li').each do |li|
          content = li.css('a').first.content rescue ""
          Product.create(:upc => rand(1<<51), :name => content) unless content.blank? 
        end
      end
    rescue
      # do nothing
    end
  end
  
end
