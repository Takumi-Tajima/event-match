class EventsController < ApplicationController
  def index
    @event = current_user.events.unchecked.first
  end
end
