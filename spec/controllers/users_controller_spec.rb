require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'without login' do
    describe "GET #index" do
      it "redirects to login page" do
        get :index, params: {}
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe 'with login admin' do
    login_admin

    describe "GET #index" do
      it "assigns all applists as @applists" do
        users = FactoryGirl.create_list(:user, 2)
        get :index, params: {}
        expect(assigns(:users)).to eq [current_user, *users]
      end
    end
  end

  describe 'with login user not admin' do
    login_user

    describe "GET #index" do
      it "raises RoutingError" do
        expect {
          get :index, params: {}
        }.to raise_error(ActionController::RoutingError)
      end
    end
  end

end
