class User < ApplicationRecord
  has_secure_password
  has_many :credit_cards
  has_many :transactions
  validates :email_address, presence: true, uniqueness: true
end
