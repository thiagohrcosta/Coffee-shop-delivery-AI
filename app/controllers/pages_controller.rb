class PagesController < ApplicationController
  def home
    @products = Product.all
    @cart = Cart.find_by(user_id: current_user.id)
  end
end
