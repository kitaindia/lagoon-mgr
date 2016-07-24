class GooglePlayAppsController < ApplicationController
  before_action :set_google_play_app, only: [:show, :edit, :update, :destroy]

  # GET /google_play_apps
  # GET /google_play_apps.json
  def index
    @google_play_apps = GooglePlayApp.all
  end

  # GET /google_play_apps/1
  # GET /google_play_apps/1.json
  def show
  end

  # GET /google_play_apps/new
  def new
    @google_play_app = GooglePlayApp.new
  end

  # GET /google_play_apps/1/edit
  def edit
  end

  # POST /google_play_apps
  # POST /google_play_apps.json
  def create
    @google_play_app = GooglePlayApp.new(google_play_app_params)

    respond_to do |format|
      if @google_play_app.save
        format.html { redirect_to @google_play_app, notice: 'Google play app was successfully created.' }
        format.json { render :show, status: :created, location: @google_play_app }
      else
        format.html { render :new }
        format.json { render json: @google_play_app.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /google_play_apps/1
  # PATCH/PUT /google_play_apps/1.json
  def update
    respond_to do |format|
      if @google_play_app.update(google_play_app_params)
        format.html { redirect_to @google_play_app, notice: 'Google play app was successfully updated.' }
        format.json { render :show, status: :ok, location: @google_play_app }
      else
        format.html { render :edit }
        format.json { render json: @google_play_app.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /google_play_apps/1
  # DELETE /google_play_apps/1.json
  def destroy
    @google_play_app.destroy
    respond_to do |format|
      format.html { redirect_to google_play_apps_url, notice: 'Google play app was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_google_play_app
      @google_play_app = GooglePlayApp.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def google_play_app_params
      params.require(:google_play_app).permit(:name, :icon_url)
    end
end
