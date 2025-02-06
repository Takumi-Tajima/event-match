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

  def fetch_events_from_google_calendar
    response = GoogleCustomSearchApi.search('岡山県 イベント')
    events_data = parse_events(response)

    events_data.each do |event_data|
      events.create!(
        name: event_data[:name],
        start_time: event_data[:start_time],
        end_time: event_data[:end_time],
        url: event_data[:url]
      )
    end
  end

  def parse_events(response)
    response['items'].map do |item|
      {
        name: item['title'],
        date: item.dig('pagemap', 'Event', 0, 'startDate'),
        start_time: item.dig('pagemap', 'Event', 0, 'startDate') || item['snippet'],
        end_time: item.dig('pagemap', 'Event', 0, 'endDate'),
        url: item['link'],
      }
    end
  end
end
