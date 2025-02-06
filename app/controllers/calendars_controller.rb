class CalendarsController < ApplicationController
  def create
    current_user.create_event(params[:summary], params[:start_date], params[:end_date], params[:url])
    current_user.events.find(params[:id]).update!(checked: true)
    redirect_to events_path
  end
end
