class Merchant < ApplicationRecord

  validates_presence_of :name

  has_many :invoices
  has_many :items

  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices

  def self.filter_by_name(name)
    @merchants = self.where(Merchant.arel_table[:name].lower.matches("%#{name.downcase}%"))
  end

  def self.filter_by_created_at(created_at)
    @merchants = self.where(created_at: created_at)
  end

  def self.filter_by_updated_at(updated_at)
    @merchants = self.where(updated_at: updated_at)
  end

  def self.most_revenue(quantity)
    @merchants = self.joins(:invoice_items, :transactions).where(transactions: {result: 1}).select('merchants.*, sum(invoice_items.unit_price*invoice_items.quantity) as revenue').group(:id).order(revenue: :desc).limit(quantity)
  end

  def self.most_items(quantity)
    @merchants = Merchant.joins(:invoice_items, :transactions).where(transactions: {result: 1}).select('merchants.*, sum(invoice_items.quantity) as total_quantity').group(:id).order(total_quantity: :desc).limit(quantity)
  end

  def self.total_revenue(start_date, end_date)
    @invoices = Invoice.joins(:invoice_items, :transactions).where(transactions: {result: 1})
    @invoices.where(:created_at => start_date..end_date).sum('invoice_items.quantity * invoice_items.unit_price')
  end

  def self.revenue(merchant_id)
    Merchant.joins(:invoices).joins(:invoice_items).joins(:transactions).where(merchants: {id: merchant_id}).where(transactions: {result: 1}).sum('invoice_items.unit_price*invoice_items.quantity')
  end

end
