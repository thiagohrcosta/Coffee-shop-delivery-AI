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
end
