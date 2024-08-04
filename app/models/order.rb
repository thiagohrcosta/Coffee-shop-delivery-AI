class Order < ApplicationRecord
  belongs_to :cart
  has_one :payment
  
  enum status: { pending: "pending", paid: "paid", canceled: "canceled", refund: "refund" }
end
