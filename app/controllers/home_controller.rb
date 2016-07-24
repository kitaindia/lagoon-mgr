class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    if current_user.user_applists.where(is_done: false).empty?
      #
      # get no-inreview app
      #
      app = Applist.includes(:users).where(users: {id: nil}).first

      #
      # set app in-review
      #
      UserApplist.create(user: current_user, applist: app, is_done: false)
    end

    @reviewing_apps = current_user.applists.reviewing

    @done_reviewing_apps = current_user.applists.is_done
  end

end
