class LocationAuthenticatesController < ApplicationController
  def new
  end

  def create
    current_user.update_location!(params[:lat], params[:lng])
    redrect_to events_url
  end
end