class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    if current_user.is_reviewer and current_user.user_applists.where(is_done: false).empty?
      #
      # get no-in-review app
      #
      app = Applist.includes(:users).where(users: {id: nil}, is_scraped: true).first

      #
      # set app in-review
      #
      UserApplist.create(user: current_user, applist: app, is_done: false) if app
    end

    @reviewing_apps = current_user.user_applists.reviewing.includes(applist: [:itunes_app, :google_play_app])
    @done_reviewing_apps =
      current_user.user_applists
      .is_done.includes(applist: [:itunes_app, :google_play_app])
      .order('review_done_datetime DESC')
  end

end
