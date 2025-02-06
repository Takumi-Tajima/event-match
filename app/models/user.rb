class User < ApplicationRecord
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

  def events_fetch_from_google_calendar
    GoogleCustomSearchApi.search('岡山県 イベント')
  end
end
