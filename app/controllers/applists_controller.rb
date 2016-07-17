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
