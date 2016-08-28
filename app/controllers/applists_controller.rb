require 'open-uri'
require 'csv'

class ApplistsController < ApplicationController

  before_action :authenticate_user!
  before_action :authenticate_admin_user!
  before_action :set_applist, only: [:show, :edit, :update, :destroy]

  # GET /applists
  # GET /applists.json
  def index
    @applists = Applist.all
  end

  # GET /applists/1
  # GET /applists/1.json
  def show
  end

  # GET /applists/new
  def new
    @applist = Applist.new
  end

  # GET /applists/1/edit
  def edit
  end

  # POST /applists/1/scrape_app
  def scrape_app
    applist = Applist.find(params[:applist_id])

    scrape_success = false

    if applist.itunes_url
      country_code_match = applist.itunes_url.match(/itunes\.apple\.com\/(.+?)\//)
      app_id_match = applist.itunes_url.match(/id(\d+)/)

      if country_code_match and app_id_match

        country_code = country_code_match[1]
        app_id = app_id_match[1]
        response = open("https://itunes.apple.com/#{country_code}/lookup?id=#{app_id}")
        code, message = response.status
        if code == '200'
          json = ActiveSupport::JSON.decode(response.read)
          result = json['results'][0]
          @itunes_app = ItunesApp.new(
            icon_url: result['artworkUrl100'],
            name: result['trackName'],
            applist_id: params[:applist_id]
          )

          if @itunes_app.save
            scrape_success = true
          end
        end
      end
    end

    if applist.google_play_url
      app_id_match = applist.google_play_url.match(/id=(.+)$/)

      if app_id_match
        app_id = app_id_match[1]
        app = MarketBot::Play::App.new(app_id)
        begin
          app.update
          @google_app = GooglePlayApp.new(
            icon_url: app.cover_image_url,
            name: app.title,
            applist_id: params[:applist_id]
          )
          if @google_app.save
            scrape_success = true
          end
        rescue MarketBot::NotFoundError => e
          puts e.message
        end
      end
    end

    if scrape_success
      redirect_to :applists, notice: "App detail scraping Success!"
    else
      redirect_to :applists, notice: "something went wrong"
    end

  end

  def done_app
    applist = Applist.find(params[:applist_id])
    user_applist = applist.user_applists.find_by(user: current_user)

    if user_applist.update_attributes(is_done: true)
      redirect_to :root, notice: "App was successfully done!"
    else
      redirect_to :root, notice: "something went wrong"
    end
  end

  # POST /applists
  # POST /applists.json
  def create
    @applist = Applist.new(applist_params)

    if @applist.save
      redirect_to @applist, notice: 'Applist was successfully created.'
    else
      render :new
    end
  end

  def import
    if params[:csv_file].blank?
      redirect_to :applists, alert: 'You must select CSV file'
    else
      num = Applist.import(params[:csv_file])
      redirect_to :applists, notice: "Add #{num.to_s} applists was successfully created."
    end
  end

  # PATCH/PUT /applists/1
  # PATCH/PUT /applists/1.json
  def update
    if @applist.update(applist_params)
      redirect_to @applist, notice: 'Applist was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /applists/1
  # DELETE /applists/1.json
  def destroy
    @applist.destroy
    redirect_to applists_url, notice: 'Applist was successfully destroyed.'
  end

  private

  def authenticate_admin_user!
    unless current_user.is_admin
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_applist
    @applist = Applist.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def applist_params
    params.require(:applist).permit(:google_play_url, :itunes_url)
  end
end
