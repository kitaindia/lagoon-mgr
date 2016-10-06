class ApplistsController < ApplicationController

  before_action :authenticate_user!
  before_action :authenticate_admin_user!,
                only: [:index, :show, :new, :edit, :scrape_app, :update, :create, :import, :destroy]
  before_action :set_applist, only: [:show, :edit, :update, :destroy]

  # GET /applists
  # GET /applists.json
  def index
    @applists = Applist.includes(user_applists: [:user]).page(params[:page])
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

    if applist.scrape_app
      redirect_to :applists, notice: "App detail scraping Success!"
    else
      redirect_to :applists, notice: "something went wrong"
    end
  end

  def done_app
    applist = Applist.find(params[:applist_id])
    user_applist = applist.user_applists.find_by(user: current_user)

    if user_applist.update(is_done: true, review_done_datetime: Time.zone.now)
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
      if @applist.scrape_app
        redirect_to @applist, notice: 'Applist was successfully created. Success to get App Detail.'
      else
        redirect_to @applist, notice: 'Applist was successfully created. But failed to get App detail.'
      end
    else
      render :new
    end
  end

  def import
    if params[:csv_text].blank?
      redirect_to :applists, alert: 'You must select CSV file'
    else
      @applists = Applist.import(params[:csv_text])
      @scrape_success_count = @applists.count { |applist| applist.scrape_app }

      redirect_to :applists, notice: <<EOS
Add #{@applists.count.to_s} applists was successfully created.
Success to get #{@scrape_success_count.to_s} App Detail
EOS
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

  # Use callbacks to share common setup or constraints between actions.
  def set_applist
    @applist = Applist.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def applist_params
    params.require(:applist).permit(:google_play_url, :itunes_url)
  end
end
