require 'csv'
require_relative '../../app/models/application_record'
require_relative '../../app/models/customer'

desc "Loads the csv files and seeds the database"

task csv_to_seed: :environment do
  

  system 'rails db:{drop,create,migrate}'

  CSV.foreach('./lib/customers.csv', headers: true) do |row|
    Customer.create(row.to_hash)
  end
  puts "Loaded customers.csv"

  CSV.foreach('./lib/merchants.csv', headers: true) do |row|
    Merchant.create(row.to_hash)
  end
  puts "Loaded merchants.csv"

  CSV.foreach('./lib/items.csv', headers: true) do |row|
    merchant = Merchant.find(row[4])
    row[3] = row[3].to_i/100.to_f
    merchant.items.create(row.to_hash)
  end
  puts "Loaded items.csv"

  CSV.foreach('./lib/invoices.csv', headers: true) do |row|
    if row[3] == 'shipped'
      row[3] = 0
    end
    Invoice.create(row.to_hash)
  end
  puts "Loaded invoices.csv"

  CSV.foreach('./lib/transactions.csv', headers: true) do |row|
    if row[4] == 'success'
      row[4] = 1
    elsif row[4] == 'failed'
      row[4] = 0
    end
    Transaction.create(row.to_hash)
  end
  puts "Loaded transactions.csv"

  CSV.foreach('./lib/invoice_items.csv', headers: true) do |row|
    row[4] = row[4].to_i/100.to_f
    InvoiceItem.create(row.to_hash)
  end
  puts "Loaded invoice_items.csv"

  # Merchant with the most revenue
  # Merchant.joins(:invoices).joins(:invoice_items).joins(:transactions).where(transactions: {result: 0}).select('merchants.*, sum(invoice_items.unit_price*invoice_items.quantity) as revenue').group(:id).order(revenue: :desc).first 
  # Merchant with the most number of items sold
  # Merchant.joins(:invoices).joins(:transactions).joins(:invoice_items).where(transactions: {result: 1}).select('merchants.*, sum(invoice_items.quantity) as total_quantity').group(:id).order(total_quantity: :desc).first
  # Merchant with the most revenue over a date range
  
  # Total revenue for specific merchant
  # Merchant.joins(:invoices).joins(:invoice_items).joins(:transactions).where(merchants: {id: 1}).sum(invoice_items.unit_price*invoice_items.quantity).group(:id)
end
