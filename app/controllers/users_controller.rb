class UsersController < ApplicationController

  before_action :authenticate_user!
  before_action :authenticate_admin_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.where(is_admin: false)
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new
    end
  end


  def update
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
      redirect_to users_url, notice: 'User was successfully destroyed.'
    end
  end

  private
  def authenticate_admin_user!
    unless current_user.is_admin
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
