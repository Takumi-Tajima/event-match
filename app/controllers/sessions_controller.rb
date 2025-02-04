class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[create]

  def create
    if user = User.from_omniauth(request.env['omniauth.auth'])
      session[:user_id] = user.id
    end
    redirect_to people_path
  end

  def destroy
    reset_session
    redirect_to root_path
  end
end
