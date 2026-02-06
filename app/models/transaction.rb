class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :product
  belongs_to :credit_card     
  before_create :generate_transaction_number
  before_create :calculate_total_cost
  
  private
  
  def generate_transaction_number
    self.transaction_number = Array.new(10) { [*"A".."Z", *"0".."9"].sample }.join
  end
  
  def calculate_total_cost
    self.total_cost = product.price * quantity
  end
end
