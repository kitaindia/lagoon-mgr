class UsersController < ApplicationController

  before_action :authenticate_user!, :authenticate_admin_user!

  def index
    @users = User.all
  end

  private
  def authenticate_admin_user!
    unless current_user.is_admin
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
