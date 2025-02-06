class EventsController < ApplicationController
  def index
    @event = current_user.events.unchecked.first
  end

  def update
    current_user.events.find(params[:id]).update!(checked: true)
    redirect_to events_path
  end
end
