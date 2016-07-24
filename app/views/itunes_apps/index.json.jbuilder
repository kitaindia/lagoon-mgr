json.array!(@itunes_apps) do |itunes_app|
  json.extract! itunes_app, :id, :name, :icon_url
  json.url itunes_app_url(itunes_app, format: :json)
end
