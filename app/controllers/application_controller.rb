class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :admin_user

  def current_user
    return nil if session[:user_id].nil?
    user = User.find_by_id(session[:user_id])
    if user.nil?
      return nil
    else
      user
    end
  end

  def admin_user
    user = current_user
    return nil if user.nil?
    return nil unless user.admin
    user
  end

  def ensure_that_signed_in
    redirect_to signin_path, notice: 'you should be signed in' if current_user.nil?
  end

  def ensure_that_user_is_admin
    redirect_to :back, notice: 'only website admin can do this' if !current_user.admin
  end
end
