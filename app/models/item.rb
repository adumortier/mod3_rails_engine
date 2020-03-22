class Item < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :name, :description, :unit_price

  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.filter_by_name(name)
    @items = self.where(Item.arel_table[:name].lower.matches("%#{name.downcase}%"))
  end

  def self.filter_by_description(description)
    @items = self.where(Item.arel_table[:description].lower.matches("%#{description.downcase}%"))
  end

  def self.filter_by_created_at(created_at)
    @items = self.where(created_at: created_at)
  end

  def self.filter_by_updated_at(updated_at)
    @items = self.where(updated_at: updated_at)
  end

  def self.filter_by_unit_price(unit_price)
    @items = self.where(unit_price: unit_price)
  end

end
