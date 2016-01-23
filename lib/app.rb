require 'json'
require 'date'

def setup_files
  path = File.join(File.dirname(__FILE__), '../data/products.json')
  file = File.read(path)
  $products_hash = JSON.parse(file)
  $report_file = File.new("report.txt", "w+")
end

def sum(arr)
  total = 0
  arr.each do |elem|
    total += elem
  end
  total
end

def average(arr)
  sum(arr) / arr.size
end

def discount(price, full_price)
  1 - price / full_price
end

def init_brands_hash
  $brands_hash = {}
end

def line_stars
  $report_file.write("*" * 24 + "\n")
end

def line_blank
  $report_file.write("\n")
end

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

def brand_header
	$report_file.write(" _                         _     \n")
	$report_file.write("| |                       | |    \n")
	$report_file.write("| |__  _ __ __ _ _ __   __| |___ \n")
	$report_file.write("| '_ \\| '__/ _` | '_ \\ / _` / __|\n")
	$report_file.write("| |_) | | | (_| | | | | (_| \\__ \\\n")
	$report_file.write("|_.__/|_|  \\__,_|_| |_|\\__,_|___/\n")
	line_blank
end

def product_total_sales(product)
  total_sales = 0.0
  product['purchases'].each do |purchase|
    price = Float(purchase['price'])
    total_sales += price
  end
  total_sales
end

def report_product(product)
  # Print the name of the toy
  $report_file.write("--#{product['title']}--\n")
  line_stars

  # Print the retail price of the toy
  full_price = Float(product['full-price'])
  $report_file.write("Retail Price: $#{full_price.round(2)}\n")

  # Calculate and print the total number of purchases
  num = product['purchases'].length
  $report_file.write("Total Purchases: #{num}\n")

  # Calculate and print the total amount of sales
  total_sales = product_total_sales(product)
  $report_file.write("Total Sales Volume: $#{total_sales.round(2)}\n")

  # Calculate and print the average price the toy sold for
  avg_price = total_sales / num
  $report_file.write("Average Price: $#{avg_price.round(2)}\n")

  # Calculate and print the average discount based off the average sales price
  avg_discount= discount(avg_price, full_price)
  $report_file.write("Average Discount: #{(avg_discount * 100).round(2)}%\n")

  line_stars
  line_blank
end

def report_brands_hash(brands_hash)
  # brands_hash has following form
  # { 
  #   brand => 
  #     {
  #       'stock' => [],
  #       'full-price' => [],
  #       'price' => []
  #     }
  # }
  brands_hash.each do |brand, info|
    $report_file.write(brand+"\n")
    line_stars

    num_of_stocks = sum(info['stock'])
    $report_file.write("Number of stock: #{num_of_stocks}\n")

    avg_price = average(info['full-price'])
    $report_file.write("Average Product Price: $#{avg_price.round(2)}\n")

    revenue = sum(info['price'])
    $report_file.write("Total Revenue: $#{revenue.round(2)}\n")

    line_stars
    line_blank
  end
end

def brands_hash_calculation(product)
  # Some calculation for brands_hash
  brand = product['brand']
  $brands_hash[brand] ||= {'stock' => [], 'full-price' => [], 'price' => []}
  $brands_hash[brand]['stock'].push(product['stock'])
  $brands_hash[brand]['full-price'].push(Float(product['full-price']))

  # Calculate revenue for brand
  product['purchases'].each do |purchase|
    price = Float(purchase['price'])
    $brands_hash[brand]['price'].push(price)
  end
end

def create_report
  items = $products_hash['items']
  sales_report_header
  product_header
  items.each do |product|
    report_product(product)
    brands_hash_calculation(product)
  end
  brand_header
  report_brands_hash($brands_hash)
  $report_file.close
end

def start
  setup_files
  init_brands_hash
  create_report
end

start
