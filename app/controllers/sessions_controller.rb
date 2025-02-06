class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[create]

  def create
    user = User.find_or_create_from_auth_hash(request.env['omniauth.auth'])
    log_in user if user
    user.fetch_events_from_google_calendar
    redirect_to events_path
  end

  def destroy
    reset_session
    redirect_to root_path
  end
end
