class ItunesAppsController < ApplicationController
  before_action :set_itunes_app, only: [:show, :edit, :update, :destroy]

  # GET /itunes_apps
  # GET /itunes_apps.json
  def index
    @itunes_apps = ItunesApp.all
  end

  # GET /itunes_apps/1
  # GET /itunes_apps/1.json
  def show
  end

  # GET /itunes_apps/new
  def new
    @itunes_app = ItunesApp.new
  end

  # GET /itunes_apps/1/edit
  def edit
  end

  # POST /itunes_apps
  # POST /itunes_apps.json
  def create
    @itunes_app = ItunesApp.new(itunes_app_params)

    respond_to do |format|
      if @itunes_app.save
        format.html { redirect_to @itunes_app, notice: 'Itunes app was successfully created.' }
        format.json { render :show, status: :created, location: @itunes_app }
      else
        format.html { render :new }
        format.json { render json: @itunes_app.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /itunes_apps/1
  # PATCH/PUT /itunes_apps/1.json
  def update
    respond_to do |format|
      if @itunes_app.update(itunes_app_params)
        format.html { redirect_to @itunes_app, notice: 'Itunes app was successfully updated.' }
        format.json { render :show, status: :ok, location: @itunes_app }
      else
        format.html { render :edit }
        format.json { render json: @itunes_app.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /itunes_apps/1
  # DELETE /itunes_apps/1.json
  def destroy
    @itunes_app.destroy
    respond_to do |format|
      format.html { redirect_to itunes_apps_url, notice: 'Itunes app was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_itunes_app
      @itunes_app = ItunesApp.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def itunes_app_params
      params.require(:itunes_app).permit(:name, :icon_url)
    end
end
