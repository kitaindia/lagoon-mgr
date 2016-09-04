class Applist < ApplicationRecord
  has_many :user_applists
  has_many :users, through: :user_applists
  has_one :itunes_app
  has_one :google_play_app

  validates :google_play_url, allow_blank: true, format: /\A#{URI::regexp(%w(http https))}\z/
  validates :itunes_url, allow_blank: true, format: /\A#{URI::regexp(%w(http https))}\z/
  validates_with AnyFieldFillValidator, fields: [:google_play_url, :itunes_url]

  def fetch_itunes_app
    #
    # fetch app data from itunes app API
    #
    return false unless self.itunes_url

    country_code = itunes_url[/(?<=itunes\.apple\.com\/)[^\/]+/]
    app_id = itunes_url[/(?<=id)[\d]+/]

    return false if country_code.nil? or app_id.nil?

    if country_code == 'en'
      # TODO Convert ISO 639-2 Language Code
      country_code = 'us'
    end

    response = open("https://itunes.apple.com/#{country_code}/lookup?id=#{app_id}")
    code, message = response.status
    if code == '200'
      json = ActiveSupport::JSON.decode(response.read)
      result = json['results'][0]
      @itunes_app = ItunesApp.new(
        icon_url: result['artworkUrl100'],
        name: result['trackName'],
        applist_id: self.id
      )

      if @itunes_app.save
        return true
      end
    end

    return false
  end

  def fetch_google_play
    #
    # fetch data from google play Web site
    #
    return false unless self.google_play_url

    app_id = self.google_play_url[/(?<=id=)[\S]+$/]

    return false if app_id.nil?

    app = MarketBot::Play::App.new(app_id)
    begin
      app.update
      @google_app = GooglePlayApp.new(
        icon_url: app.cover_image_url,
        name: app.title,
        applist_id: self.id
      )
      if @google_app.save
        scrape_success = true
        return true
      end
    rescue MarketBot::NotFoundError => e
      puts e.message
    end

    return false
  end

  def self.import(rows)

    imported_num = 0
    #
    # Import app data if not exists
    #
    csv = CSV.new(rows)
    csv.each do |row|
      google_play_url = row[0].strip
      itunes_url = row[1].strip
      applist = where([ "google_play_url = ? or itunes_url = ?", google_play_url, itunes_url ])

      if applist.empty?
        applist = new
        applist.attributes = {google_play_url: google_play_url, itunes_url: itunes_url}

        if applist.valid?
          applist.save
          imported_num += 1
        end
      end
    end

    imported_num
  end
end
