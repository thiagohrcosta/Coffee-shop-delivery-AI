class CartsController < ApplicationController
  before_action :user_is_logged?
  before_action :set_cart, only: [:show]

  def show;end

  def new;end

  def create
    @product = Product.find(params[:product_id])

    if user_has_active_cart?
      @cart = Cart.find_by(user_id: current_user.id)
      @cart_product = CartProduct.create!(cart_id: @cart.id, product_id: @product.id)
      update_order_total_price(@cart.id)
      redirect_to cart_path(@cart.id)
    else
      ActiveRecord::Base.transaction do
        @cart = Cart.new(user_id: current_user.id)
        @cart.user_id = current_user.id
  
        if @cart.save
          @cart_product = CartProduct.create!(cart_id: @cart.id, product_id: @product.id)
          redirect_to cart_path(@cart.id), notice: 'Product added to cart.'
        else
          raise ActiveRecord::Rollback
        end
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    puts "ERROR: #{e.message}"
    redirect_to product_path(@product.id), alert: 'Fail to add product to cart.'
  end


  def edit;end

  def update;end

  def destroy;end

  private

  def update_order_total_price(cart_id)
    @cart = Cart.find(cart_id)
    @order = Order.find_by(cart_id: cart_id)
    @order.update(total_price: @cart.products.sum(:price))
  end

  def user_has_active_cart?
    @cart = Cart.find_by(user_id: current_user.id)

    @cart.present? ? true : false
  end

  def set_cart
    @cart = Cart.find(params[:id])
  end

  def cart_params
    params.require(:cart).permit(:product_id)
  end
end
