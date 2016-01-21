require 'json'

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

def create_report
  items = $products_hash['items']
  items.each do |product|
    # Print the name of the toy
    puts product['title']
    line_sep

    # Print the retail price of the toy
    price = Float(product['full-price']).round(2)
    puts "price: $#{price}"

    # Calculate and print the total number of purchases
    num = product['purchases'].length
    puts "num purchases: #{num}"

    # Calculate the total amount of sales
    total_sales = 0
    product['purchases'].each do |purchase|
      total_sales += Float(purchase['price'])
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
end

def start
  setup_files
  create_report
end

start
