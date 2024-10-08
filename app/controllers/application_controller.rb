class ApplicationController < ActionController::Base
  def user_is_admin?
    if current_user.access != "admin"
      redirect_to user_session_path
    end
  end

  def user_is_logged?
    unless current_user
      redirect_to user_session_path
    end
  end

  def user_cart
    if current_user.present? && current_user.access == "user"
      @cart = Cart.find_by(user_id: current_user.id)

      @cart.is_active == true ? @cart : @cart = nil
    end 
  end
end
