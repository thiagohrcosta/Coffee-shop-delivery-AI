class Order < ApplicationRecord
  belongs_to :cart
  has_one :payment
  enum status: { pendente: "pending", pago: "paid", cancelado: "canceled", estornado: "refund" }

end
