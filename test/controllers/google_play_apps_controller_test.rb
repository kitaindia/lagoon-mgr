require 'test_helper'

class GooglePlayAppsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @google_play_app = google_play_apps(:one)
  end

  test "should get index" do
    get google_play_apps_url
    assert_response :success
  end

  test "should get new" do
    get new_google_play_app_url
    assert_response :success
  end

  test "should create google_play_app" do
    assert_difference('GooglePlayApp.count') do
      post google_play_apps_url, params: { google_play_app: { icon_url: @google_play_app.icon_url, name: @google_play_app.name } }
    end

    assert_redirected_to google_play_app_url(GooglePlayApp.last)
  end

  test "should show google_play_app" do
    get google_play_app_url(@google_play_app)
    assert_response :success
  end

  test "should get edit" do
    get edit_google_play_app_url(@google_play_app)
    assert_response :success
  end

  test "should update google_play_app" do
    patch google_play_app_url(@google_play_app), params: { google_play_app: { icon_url: @google_play_app.icon_url, name: @google_play_app.name } }
    assert_redirected_to google_play_app_url(@google_play_app)
  end

  test "should destroy google_play_app" do
    assert_difference('GooglePlayApp.count', -1) do
      delete google_play_app_url(@google_play_app)
    end

    assert_redirected_to google_play_apps_url
  end
end
