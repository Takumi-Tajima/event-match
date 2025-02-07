class LocationAuthenticatesController < ApplicationController
  def new
  end

  def create
    current_user.update_location(location_params)
    redirect_to events_url
  end

  private

  def location_params
    params.require(:location).permit(:latitude, :longitude)
  end
end
