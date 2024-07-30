class OrdersController < ApplicationController
  def create
    @cart = Cart.find(params[:cart_id])
    total_price = calculate_total_price(@cart)

    @order = Order.new(cart: @cart, total_price: total_price, status: "pending")

    if @order.save
      @payment = Payment.create!(
        order_id: @order.id,
        amount: @order.total_price,
        status: "pending",
        transaction_id: nil,
        paid_at: nil
      )

      @cart.update(is_active: false)
      redirect_to payment_path(@payment.id)
    end
  end

  private

  def calculate_total_price(cart)
    total = cart.cart_products.inject(0) do |sum, cart_product|
      sum + (cart_product.amount * cart_product.product.price)
    end
    total.round(2)
  end
end
