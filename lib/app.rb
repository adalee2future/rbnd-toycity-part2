require 'json'
require 'date'

def setup_files
  path = File.join(File.dirname(__FILE__), '../data/products.json')
  file = File.read(path)
  $products_hash = JSON.parse(file)
  $report_file = File.new("report.txt", "w+")
end

# print some stars to seperate lines
def line_sep
  $report_file.write("*" * 24 + "\n")
end

# print blank line
def line_blank
  $report_file.write("\n")
end

# sales report header
def sales_report_header
  $report_file.write("  #####                                 ######\n")
  $report_file.write(" #     #   ##   #      ######  ####     #     # ###### #####   ####  #####  #####\n")
  $report_file.write(" #        #  #  #      #      #         #     # #      #    # #    # #    #   #\n")
  $report_file.write("  #####  #    # #      #####   ####     ######  #####  #    # #    # #    #   #\n")
  $report_file.write("       # ###### #      #           #    #   #   #      #####  #    # #####    #\n")
  $report_file.write(" #     # #    # #      #      #    #    #    #  #      #      #    # #   #    #\n")
  $report_file.write("  #####  #    # ###### ######  ####     #     # ###### #       ####  #    #   #\n")
  $report_file.write("********************************************************************************\n")
  line_blank
end

# puts product report header
def product_header
  $report_file.write("                       _            _       \n")
  $report_file.write("                      | |          | |      \n")
  $report_file.write("   _ __  _ __ ___   __| |_   _  ___| |_ ___ \n")
  $report_file.write("  | '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|\n")
  $report_file.write("  | |_) | | | (_) | (_| | |_| | (__| |_\\__ \\\n")
  $report_file.write("  | .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/\n")
  $report_file.write("  | |                                       \n")
  $report_file.write("  |_|                                       \n")
  line_blank
end

# print brands header
def brand_header
	$report_file.write(" _                         _     \n")
	$report_file.write("| |                       | |    \n")
	$report_file.write("| |__  _ __ __ _ _ __   __| |___ \n")
	$report_file.write("| '_ \\| '__/ _` | '_ \\ / _` / __|\n")
	$report_file.write("| |_) | | | (_| | | | | (_| \\__ \\\n")
	$report_file.write("|_.__/|_|  \\__,_|_| |_|\\__,_|___/\n")
	line_blank
end

# given brands_hash, print brands report
def report_brands_hash(brands_hash)
  brands_hash.each do |brand, info|
    $report_file.write(brand+"\n")
    line_sep
    $report_file.write("Number of Products: #{info['stock']}\n")
    $report_file.write("Average Product Price: $#{(info['full-price'] / info['count']).round(2)}\n")
    $report_file.write("Total Revenue: $#{info['revenue'].round(2)}\n")
    line_sep
    line_blank
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
    $report_file.write("--#{product['title']}--\n")
    line_sep

    # Print the retail price of the toy
    full_price = Float(product['full-price']).round(2)
    $report_file.write("Retail Price: $#{full_price}\n")

    # Calculate and print the total number of purchases
    num = product['purchases'].length
    $report_file.write("Total Purchases: #{num}\n")

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
    $report_file.write("Total Sales Volume: $#{total_sales.round(2)}\n")

    # Calculate and print the average price the toy sold for
    avg_price = total_sales / num
    $report_file.write("Average Price: $#{avg_price.round(2)}\n")

    # Calculate and print the average discount based off the average sales price
    discount = 1 - avg_price / Float(product['full-price'])
    $report_file.write("Average Discount: #{(discount * 100).round(2)}%\n")

    line_sep
    line_blank
  end
  brand_header
  report_brands_hash(brands_hash)
  $report_file.close
end

def start
  setup_files
  create_report
end

start
