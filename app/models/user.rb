require 'google/api_client/client_secrets'
require 'google/apis/calendar_v3'

class User < ApplicationRecord
  has_many :events, dependent: :destroy

  def self.find_or_create_from_auth_hash(auth_hash)
    name = auth_hash['info']['name']
    email = auth_hash['info']['email']
    token = auth_hash['credentials']['token']
    refresh_token = auth_hash['credentials']['refresh_token']

    User.find_or_create_by!(email: email) do |user|
      user.name = name
      user.token = token
      user.refresh_token = refresh_token
    end
  end

  def google_client_secrets
    Google::APIClient::ClientSecrets.new(
      web: {
        access_token: token,
        refresh_token: refresh_token,
        client_id: Rails.application.credentials.google.client_id,
        client_secret: Rails.application.credentials.google.client_secret,
      }
    )
  end

  def google_calendar_service
    client = google_client_secrets.to_authorization
    client.fetch_access_token!
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client
    service
  end

  def fetch_events_from_google_calendar
    response = GoogleCustomSearchApi.search('ウォーカーイベント 岡山県 イベント')
    events_data = parse_events(response)

    events_data.each do |event_data|
      next if event_data[:end_date] < Time.zone.now

      events.find_or_create_by!(
        name: event_data[:name],
        description: event_data[:description],
        start_date: event_data[:start_date],
        end_date: event_data[:end_date],
        image: event_data[:image],
        url: event_data[:url]
      )
    end
  end

  def parse_events(response)
    response['items'].filter_map { |item| item['pagemap']['Event']&.first }.map do |event|
      {
        name: event['name'],
        description: event['description'],
        start_date: event['startDate'],
        end_date: event['endDate'],
        image: event['image'],
        url: event['url'],
      }
    end
  end

  def create_event(summary, start_date, end_date, url)
    calendar_service = google_calendar_service
    event = Google::Apis::CalendarV3::Event.new(
      summary: summary,
      description: url,
      start: {
        date: start_date.to_date.to_s,
        time_zone: 'Asia/Tokyo',
      },
      end: {
        date: end_date.to_date.to_s,
        time_zone: 'Asia/Tokyo',
      }
    )
    calendar_service.insert_event('primary', event)
  end
end
