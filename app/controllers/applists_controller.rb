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

    #WIP only itunes_url
    itunes_url = applist.itunes_url
    country_code_match = itunes_url.match(/itunes\.apple\.com\/(.+?)\//) if itunes_url
    app_id_match = itunes_url.match(/id(\d+)/) if itunes_url
    if country_code_match and app_id_match
      country_code = country_code_match[1]
      app_id = app_id_match[1]
      response = open("https://itunes.apple.com/#{country_code}/lookup?id=#{app_id}")
      code, message = response.status
      if code == '200'
        json = ActiveSupport::JSON.decode(response.read)
        result = json['results'][0]
        icon_url = result['artworkUrl100']
        name = result['trackName']
        @itunes_app = ItunesApp.new(icon_url: icon_url, name: name, applist_id: params[:applist_id])
        @itunes_app.save()
      end
    end
  end

  def done_app
    applist = Applist.find(params[:applist_id])
    user_applist = applist.user_applists.find_by(user: current_user)
    user_applist.update_attributes(is_done: true)
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
