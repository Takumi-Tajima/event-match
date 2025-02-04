class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :authenticate_user!
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
end
