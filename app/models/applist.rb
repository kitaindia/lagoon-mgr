class Applist < ApplicationRecord
  has_many :user_applists, dependent: :delete_all
  has_many :users, through: :user_applists
  has_one :itunes_app, dependent: :destroy
  has_one :google_play_app, dependent: :destroy

  validates :google_play_url, uniqueness: true, allow_blank: true
  validates :itunes_url, uniqueness: true, allow_blank: true
  validates_with AnyFieldFillValidator, fields: [:google_play_url, :itunes_url]
  validate :must_be_itunes_url, :must_be_google_play_url

  def scrape_app

    Applist.transaction do
      itunes_url.present? && fetch_itunes_app.save!
      google_play_url.present? && fetch_google_play.save!

      update(is_scraped: true)
    end
    rescue => e
      puts e
      return
  end

  def fetch_itunes_app
    #
    # fetch app data from itunes app API
    #
    params = itunes_app_params
    return unless params

    begin
      response = open("https://itunes.apple.com/#{params[:country_code]}/lookup?id=#{params[:app_id]}")
      code, message = response.status
      if code == '200'
        json = ActiveSupport::JSON.decode(response.read)
        result = json['results'][0]
        itunes_app = ItunesApp.new(
          icon_url: result['artworkUrl100'],
          name: result['trackName'],
          applist_id: self.id
        )
      end
    end
  end

  def fetch_google_play
    #
    # fetch data from google play Web site
    #
    params = google_play_params
    return unless params

    app = MarketBot::Play::App.new(params[:app_id])
    begin
      app.update
      google_play_app = GooglePlayApp.new(
        icon_url: app.cover_image_url,
        name: app.title,
        applist_id: self.id
      )
    end
  end

  def self.import(rows)
    #
    # Import app data if not exists
    #
    applists = []
    CSV.new(rows).to_a.each do |row|
      google_play_url = row[0] ? row[0].strip : row[0]
      itunes_url = row[1] ? row[1].strip : row[1]
      applist = new(google_play_url: google_play_url, itunes_url: itunes_url)
      applists << applist if applist.save
    end
    applists
  end

  private

  def must_be_itunes_url
    return if itunes_url.nil?

    unless URI(itunes_url).hostname == 'itunes.apple.com'
      errors.add(:itunes_url, 'itunes_url field must be itunes_url')
    end
  end

  def must_be_google_play_url
    return if google_play_url.nil?

    unless URI(google_play_url).hostname == 'play.google.com'
      errors.add(:google_play_url, 'google_play_url field must be google_play_url')
    end
  end

  def itunes_app_params

    return unless itunes_url

    country_code = itunes_url[/(?<=itunes\.apple\.com\/)[^\/]+/]
    app_id = itunes_url[/(?<=id)[\d]+/]

    return if country_code.nil? or app_id.nil?

    if country_code == 'en'
      # TODO Convert ISO 639-2 Language Code
      country_code = 'us'
    end

    {country_code: country_code, app_id: app_id}
  end

  def google_play_params

    return unless google_play_url

    app_id = google_play_url[/(?<=id=)[\S]+$/]

    return if app_id.nil?

    {app_id: app_id}
  end

end
