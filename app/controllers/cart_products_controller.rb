class CartProductsController < ApplicationController
  before_action :set_cart_product, only: [:destroy]

  def destroy
    cart_id = @cart_product.cart_id

    if @cart_product.destroy
      update_order_total_price(cart_id)
      redirect_to cart_path(cart_id)
    end
  end

  private

  def update_order_total_price(cart_id)
    @cart = Cart.find(cart_id)
    @order = Order.find_by(cart_id: cart_id)
    @order.update(total_price: @cart.products.sum(:price))
  end

  def set_cart_product
    @cart_product = CartProduct.find(params[:id])
  end
end
