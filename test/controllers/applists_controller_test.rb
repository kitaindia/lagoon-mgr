require 'test_helper'

class ApplistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @applist = applists(:one)
  end

  test "should get index" do
    get applists_url
    assert_response :success
  end

  test "should get new" do
    get new_applist_url
    assert_response :success
  end

  test "should create applist" do
    assert_difference('Applist.count') do
      post applists_url, params: { applist: { google_play_uid: @applist.google_play_uid, itunes_uid: @applist.itunes_uid } }
    end

    assert_redirected_to applist_url(Applist.last)
  end

  test "should show applist" do
    get applist_url(@applist)
    assert_response :success
  end

  test "should get edit" do
    get edit_applist_url(@applist)
    assert_response :success
  end

  test "should update applist" do
    patch applist_url(@applist), params: { applist: { google_play_uid: @applist.google_play_uid, itunes_uid: @applist.itunes_uid } }
    assert_redirected_to applist_url(@applist)
  end

  test "should destroy applist" do
    assert_difference('Applist.count', -1) do
      delete applist_url(@applist)
    end

    assert_redirected_to applists_url
  end
end
