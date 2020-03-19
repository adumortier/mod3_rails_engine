require 'csv'
require_relative '../../app/models/application_record'
require_relative '../../app/models/customer'

desc "Loads the csv files and seeds the database"

task csv_to_seed: :environment do

  CSV.foreach(Rails.root.join('lib/customers.csv'), headers: true) do |row|
    Customer.new({
      first_name: row[1],
      last_name: row[2]
    })
    require 'pry'; binding.pry
    
  end
  puts "Loaded customers.csv"

  CSV.foreach(Rails.root.join('lib/merchants.csv'), headers: true) do |row|
  
  Merchant.create({
    name: row[1],
  })
  end
  puts "Loaded merchants.csv"

  CSV.foreach(Rails.root.join('lib/items.csv'), headers: true) do |row|
  merchant = Merchant.find(row[4])  
  merchant.items.create({
    name: row[1],
    description: row[2],
    unit_price: (row[3].to_i/100.to_f),
  })
  end
  puts "Loaded items.csv"

  CSV.foreach(Rails.root.join('lib/invoices.csv'), headers: true) do |row|
    if row[3] == 'shipped'
      status = 0
    end

    Invoice.create({
    customer_id: row[1],
    merchant_id: row[2],
    status: status
    })
  end
  puts "Loaded invoices.csv"

end
