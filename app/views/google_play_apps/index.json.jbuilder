json.array!(@google_play_apps) do |google_play_app|
  json.extract! google_play_app, :id, :name, :icon_url
  json.url google_play_app_url(google_play_app, format: :json)
end
