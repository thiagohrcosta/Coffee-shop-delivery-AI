class PagesController < ApplicationController
  def home
    @products = Product.all
    if current_user.present? && current_user.access == "user"
      @cart = Cart.find_by(user_id: current_user.id)
    end 
  end
end
