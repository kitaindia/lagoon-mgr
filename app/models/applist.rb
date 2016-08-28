class Applist < ApplicationRecord
  has_many :user_applists
  has_many :users, through: :user_applists
  has_one :itunes_app
  has_one :google_play_app

  validates :google_play_url, allow_blank: true, format: /\A#{URI::regexp(%w(http https))}\z/
  validates :itunes_url, allow_blank: true, format: /\A#{URI::regexp(%w(http https))}\z/
  validates_with AnyFieldFillValidator, fields: [:google_play_url, :itunes_url]

  def self.import(file)

    imported_num = 0
    #
    # Import app data if not exists
    #
    open(file.path) do |f|
      csv = CSV.new(f, :headers => :first_row)
      csv.each do |row|
        next if row.header_row?

        table = Hash[[row.headers, row.fields].transpose]
        applist = where([ "google_play_url = ? or itunes_url = ?", table["google_play_url"], table["itunes_url"] ])

        if applist.empty?
          applist = new
          applist.attributes = {google_play_url: table["google_play_url"], itunes_url: table["itunes_url"]}

          if applist.valid?
            applist.save
            imported_num += 1
          end
        end
      end
    end

    imported_num
  end
end
