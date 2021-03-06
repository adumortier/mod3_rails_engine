class Invoice < ApplicationRecord
  belongs_to :merchant
  belongs_to :customer
  has_many :transactions

  validates_presence_of :status

  has_many :invoice_items
  has_many :items, through: :invoice_items

  enum status: %w(shipped)
  
end
