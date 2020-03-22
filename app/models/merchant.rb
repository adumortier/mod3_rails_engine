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

  def total_revenue
    #  invoices.joins(:invoice_items).joins(:transactions).where(transactions: {result: 0}).select('merchants.*, sum(invoice_items.unit_price*invoice_items.quantity) as revenue')
  end


end
