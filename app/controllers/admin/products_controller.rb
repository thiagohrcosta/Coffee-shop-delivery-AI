class Admin::ProductsController < ApplicationController
  before_action :user_is_logged?
  before_action :user_is_admin?
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all
  end

  def show;end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_product_path(@product.id)
    else
      render :new
    end
  end

  def edit;end

  def update
    if @product.update(product_params)
      redirect_to admin_product_path(@product.id)
    else
      render :edit
    end
  end

  def destroy
    if @product.destroy
      redirect_to admin_products_path
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:title, :price, :description, :photos)
  end
end
