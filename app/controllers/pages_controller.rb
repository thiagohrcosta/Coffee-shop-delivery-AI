class PagesController < ApplicationController
  before_action :user_cart
  
  def home
    @products = Product.all
  end
end
