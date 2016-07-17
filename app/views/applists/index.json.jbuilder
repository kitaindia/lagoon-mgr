json.array!(@applists) do |applist|
  json.extract! applist, :id, :google_play_url, :itunes_url
  json.url applist_url(applist, format: :json)
end
