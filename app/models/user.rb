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
end
