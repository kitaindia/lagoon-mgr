require 'csv'

CSV.generate do |csv|
  csv << ["google_play_url", "itunes_url"]
  csv << ["Please write google play app URL", "Please write itunes app URL"]
end
