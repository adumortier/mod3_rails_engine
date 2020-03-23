class Transaction < ApplicationRecord
  belongs_to :invoice

  # validates :credit_card_expiration_date, presence: true
  validates_presence_of :credit_card_number
  # validates_presence_of :credit_card_expiration_date
  validates_presence_of :result
end
