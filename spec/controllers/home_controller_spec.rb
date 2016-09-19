require 'rails_helper'
#
RSpec.describe HomeController, type: :controller do
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
      it "renders index" do
        get :index, params: {}
        expect(response).to render_template("index")
      end
    end
  end

  describe 'with login user not admin' do
    login_user

    describe "GET #index" do
      it "renders index" do
        get :index, params: {}
        expect(response).to render_template("index")
      end
    end
  end

end
