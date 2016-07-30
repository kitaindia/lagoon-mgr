require 'open-uri'

class ApplistsController < ApplicationController

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

    respond_to do |format|
      if scrape_success
        applist.update_attributes(is_scraped: true)
        format.html { redirect_to :applists, notice: "App detail scraping Success!" }
      else
        format.html { redirect_to :applists, notice: "something went wrong" }
      end
    end

  end

  def done_app
    applist = Applist.find(params[:applist_id])
    user_applist = applist.user_applists.find_by(user: current_user)

    respond_to do |format|
      if user_applist.update_attributes(is_done: true)
        format.html { redirect_to :root, notice: "App was successfully done!" }
      else
        format.html { redirect_to :root, notice: "something went wrong" }
      end
    end
  end

  # POST /applists
  # POST /applists.json
  def create
    @applist = Applist.new(applist_params)

    respond_to do |format|
      if @applist.save
        format.html { redirect_to @applist, notice: 'Applist was successfully created.' }
        format.json { render :show, status: :created, location: @applist }
      else
        format.html { render :new }
        format.json { render json: @applist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /applists/1
  # PATCH/PUT /applists/1.json
  def update
    respond_to do |format|
      if @applist.update(applist_params)
        format.html { redirect_to @applist, notice: 'Applist was successfully updated.' }
        format.json { render :show, status: :ok, location: @applist }
      else
        format.html { render :edit }
        format.json { render json: @applist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /applists/1
  # DELETE /applists/1.json
  def destroy
    @applist.destroy
    respond_to do |format|
      format.html { redirect_to applists_url, notice: 'Applist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_applist
      @applist = Applist.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def applist_params
      params.require(:applist).permit(:google_play_url, :itunes_url)
    end
end
