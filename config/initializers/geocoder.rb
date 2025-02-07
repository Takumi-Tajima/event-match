Geocoder.configure(
  lookup: :google,
  api_key: Rails.application.credentials.google.api_key,
  use_https: true,
  units: :km
)
