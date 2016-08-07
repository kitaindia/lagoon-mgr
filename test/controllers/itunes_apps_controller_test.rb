# require 'test_helper'
#
# class ItunesAppsControllerTest < ActionDispatch::IntegrationTest
#   setup do
#     @itunes_app = itunes_apps(:one)
#   end
#
#   test "should get index" do
#     get itunes_apps_url
#     assert_response :success
#   end
#
#   test "should get new" do
#     get new_itunes_app_url
#     assert_response :success
#   end
#
#   test "should create itunes_app" do
#     assert_difference('ItunesApp.count') do
#       post itunes_apps_url, params: { itunes_app: { icon_url: @itunes_app.icon_url, name: @itunes_app.name } }
#     end
#
#     assert_redirected_to itunes_app_url(ItunesApp.last)
#   end
#
#   test "should show itunes_app" do
#     get itunes_app_url(@itunes_app)
#     assert_response :success
#   end
#
#   test "should get edit" do
#     get edit_itunes_app_url(@itunes_app)
#     assert_response :success
#   end
#
#   test "should update itunes_app" do
#     patch itunes_app_url(@itunes_app), params: { itunes_app: { icon_url: @itunes_app.icon_url, name: @itunes_app.name } }
#     assert_redirected_to itunes_app_url(@itunes_app)
#   end
#
#   test "should destroy itunes_app" do
#     assert_difference('ItunesApp.count', -1) do
#       delete itunes_app_url(@itunes_app)
#     end
#
#     assert_redirected_to itunes_apps_url
#   end
# end
