require 'csv'
require_relative '../../app/models/application_record'
require_relative '../../app/models/customer'

desc "Loads the csv files and seeds the database"

task csv_to_seed: :environment do
  

  CSV.foreach(Rails.root.join('lib/customers.csv'), headers: true) do |row|
    Customer.create({
      first_name: row[1],
      last_name: row[2]
    })
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

  CSV.foreach(Rails.root.join('lib/transactions.csv'), headers: true) do |row|
    if row[4] == 'success'
      status = 1
    elsif row[4] == 'failed'
      status = 0
    end
    Transaction.create({invoice_id: row[1],credit_card_number: row[2],credit_card_expiration_date: row[3],result: status})
  end
  puts "Loaded transactions.csv"

  CSV.foreach(Rails.root.join('lib/invoice_items.csv'), headers: true) do |row|
    InvoiceItem.create({invoice_id: row[2], item_id: row[1],quantity: row[3],unit_price: (row[4].to_i/100.to_f)})
  end
  puts "Loaded invoice_items.csv"

  require 'pry'; binding.pry
  # Merchant with the most revenue
  Merchant.joins(:invoices).joins(:invoice_items).joins(:transactions).where(transactions: {result: 0}).select('merchants.*, sum(invoice_items.unit_price*invoice_items.quantity) as revenue').group(:id).order(revenue: :desc).first 
  # Merchant with the most number of items sold
  Merchant.joins(:invoices).joins(:transactions).joins(:invoice_items).where(transactions: {result: 1}).select('merchants.*, sum(invoice_items.quantity) as total_quantity').group(:id).order(total_quantity: :desc).first
  # Merchant with the most revenue over a date range
  
  # Total revenue for specific merchant
  Merchant.joins(:invoices).joins(:invoice_items).joins(:transactions).where(merchants: {id: 1}).sum(invoice_items.unit_price*invoice_items.quantity).group(:id)


end
