require 'json'
require 'date'

def setup_files
  path = File.join(File.dirname(__FILE__), '../data/products.json')
  file = File.read(path)
  $products_hash = JSON.parse(file)
  $report_file = File.new("report.txt", "w+")
end

# Print today's date
def print_today
  puts "Today's date: #{Date.today}"
end

# print some stars to seperate lines
def line_sep
  puts "*" * 25
end

# sales report header
def sales_report_header
  puts "  #####                                 ######"
  puts " #     #   ##   #      ######  ####     #     # ###### #####   ####  #####  #####"
  puts " #        #  #  #      #      #         #     # #      #    # #    # #    #   #"
  puts "  #####  #    # #      #####   ####     ######  #####  #    # #    # #    #   #"
  puts "       # ###### #      #           #    #   #   #      #####  #    # #####    #"
  puts " #     # #    # #      #      #    #    #    #  #      #      #    # #   #    #"
  puts "  #####  #    # ###### ######  ####     #     # ###### #       ####  #    #   #"
  puts "********************************************************************************"
  puts
end

# puts product report header
def product_header
  puts "                     _            _       "
  puts "                    | |          | |      "
  puts " _ __  _ __ ___   __| |_   _  ___| |_ ___ "
  puts "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|"
  puts "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\"
  puts "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/"
  puts "| |                                       "
  puts "|_|                                       "
  puts
end

# print brands header
def brand_header
	puts " _                         _     "
	puts "| |                       | |    "
	puts "| |__  _ __ __ _ _ __   __| |___ "
	puts "| '_ \\| '__/ _` | '_ \\ / _` / __|"
	puts "| |_) | | | (_| | | | | (_| \\__ \\"
	puts "|_.__/|_|  \\__,_|_| |_|\\__,_|___/"
	puts
end

# given brands_hash, print brands report
def report_brands_hash(brands_hash)
  brands_hash.each do |brand, info|
    puts brand
    line_sep
    puts "number of brand's toys: #{info['stock']}"
    puts "average price: $#{(info['full-price'] / info['count']).round(2)}"
    puts "total revenue for this brands: $#{info['revenue'].round(2)}"
    line_sep
    puts
  end
end

# create report
def create_report
  items = $products_hash['items']
  brands_hash = {}
  sales_report_header
  product_header
  items.each do |product|
    # Print the name of the toy
    puts product['title']
    line_sep

    # Print the retail price of the toy
    full_price = Float(product['full-price']).round(2)
    puts "full price: $#{full_price}"

    # Calculate and print the total number of purchases
    num = product['purchases'].length
    puts "num purchases: #{num}"

    # Some calculation for brands_hash
    brand = product['brand']
    brands_hash[brand] ||= {}
    brands_hash[brand]['count'] = 1 + brands_hash[brand].fetch('count', 0)
    brands_hash[brand]['stock'] = product['stock'] + brands_hash[brand].fetch('stock', 0)
    brands_hash[brand]['full-price'] = Float(product['full-price']) + brands_hash[brand].fetch('full-price', 0.0)

    # Calculate the total amount of sales
    # Calculate revenue for brand
    total_sales = 0.0
    brands_hash[brand]['revenue'] ||= 0.0
    product['purchases'].each do |purchase|
      price = Float(purchase['price'])
      total_sales += price
      brands_hash[brand]['revenue'] += price
    end

    # Print the total amount of sales
    puts "total amount of sales: $#{total_sales.round(2)}" 

    # Calculate and print the average price the toy sold for
    avg_price = total_sales / num
    puts "average price: $#{avg_price.round(2)}"

    # Calculate and print the average discount based off the average sales price
    discount = 1 - avg_price / Float(product['full-price'])
    puts "average discount: #{(discount * 100).round(2)}%"

    line_sep
    puts
  end
  brand_header
  report_brands_hash(brands_hash)
end

def start
  print_today
  setup_files
  create_report
end

start
