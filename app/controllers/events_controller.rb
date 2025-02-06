class EventsController < ApplicationController
  def index
    @event = current_user.events.first
  end
end
