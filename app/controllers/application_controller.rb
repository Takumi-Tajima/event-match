class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :redirect_location_authenticate_if_location_is_blank
  helper_method :current_user, :user_signed_in?

  def authenticate_user!
    return if current_user

    redirect_to root_path, alert: 'ログインしてください'
  end

  def user_signed_in?
    current_user.present?
  end

  def current_user
    return unless (user_id = session[:user_id])

    @current_user ||= User.find_by(id: user_id)
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def redirect_location_authenticate_if_location_is_blank
    redirect_to root_path if user_signed_in? && current_user.location.nil?
  end
end
