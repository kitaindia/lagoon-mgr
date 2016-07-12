json.array!(@applists) do |applist|
  json.extract! applist, :id, :google_play_uid, :itunes_uid
  json.url applist_url(applist, format: :json)
end
