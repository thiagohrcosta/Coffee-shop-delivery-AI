class CartProductsController < ApplicationController
  before_action :set_cart_product, only: [:destroy]

  def destroy
    cart_id = @cart_product.cart_id
    if @cart_product.destroy
      redirect_to cart_path(cart_id)
    end
  end

  private

  def set_cart_product
    @cart_product = CartProduct.find(params[:id])
  end
end
