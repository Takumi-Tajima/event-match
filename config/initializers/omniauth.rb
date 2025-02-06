Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, Rails.application.credentials.google.client_id, Rails.application.credentials.google.client_secret, {
    scope: %w[https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/calendar].join(' '),
    access_type: 'offline',
    prompt: 'consent',
    redirect_uri: 'http://localhost:3000/auth/google_oauth2/callback'
  }
end
OmniAuth.config.allowed_request_methods = %i[post]
