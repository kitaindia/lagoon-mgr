require 'rails_helper'

RSpec.describe ApplistsController, type: :controller do

  before do

    stub_request(:get, %r{https://play\.google\.com/store/apps/details\?gl=us&hl=id&id=jp\.naver\.line\.android\Z}).to_return(
      headers: {'Content-Type' => 'text/html'},
      body: read_data('google_jp.naver.line.android.txt')
    )

    stub_request(:get, %r{https://play\.google\.com/store/apps/details\?gl=us&hl=en&id=exampleexampleexampleexample\Z}).to_return(
      headers: {'Content-Type' => 'text/html'},
      body: read_data('google_exampleexampleexampleexample.txt')
    )

    stub_request(:get, %r{https://play\.google\.com/store/apps/details\?gl=us&hl=ja&id=jp\.co\.mixi\.monsterstrike\Z}).to_return(
      headers: {'Content-Type' => 'text/html'},
      body: read_data('google_jp.co.mixi.monsterstrike.txt')
    )

    stub_request(:get, %r{https://play\.google\.com/store/apps/details\?gl=us&hl=en&id=com\.space\.japanese\Z}).to_return(
      headers: {'Content-Type' => 'text/html'},
      body: read_data('google_com.space.japanese.txt')
    )

    stub_request(:get, %r{https://play\.google\.com/store/apps/details\?gl=us&hl=en&id=com\.maxmpz\.audioplayer\.unlock\Z}).to_return(
      headers: {'Content-Type' => 'text/html'},
      body: read_data('google_com.maxmpz.audioplayer.unlock.txt')
    )

    stub_request(:get, %r{https://play\.google\.com/store/apps/details\?gl=us&hl=in&id=com\.NeverEndingMedia\.HTMC\Z}).to_return(
      headers: {'Content-Type' => 'text/html'},
      body: read_data('google_com.NeverEndingMedia.HTMC.txt')
    )

    stub_request(:get, "https://itunes.apple.com/in/lookup?id=0123456789").to_return(
      headers: {'Content-Type' => 'text/html'},
      body: read_data('itunes_0123456789.txt')
    )

    stub_request(:get, "https://itunes.apple.com/jp/lookup?id=443904275").to_return(
      headers: {'Content-Type' => 'text/html'},
      body: read_data('itunes_443904275.txt')
    )

    stub_request(:get, "https://itunes.apple.com/jp/lookup?id=658511662").to_return(
      headers: {'Content-Type' => 'text/html'},
      body: read_data('itunes_658511662.txt')
    )

    stub_request(:get, "https://itunes.apple.com/mx/lookup?id=1040204246").to_return(
      headers: {'Content-Type' => 'text/html'},
      body: read_data('itunes_1040204246.txt')
    )

    stub_request(:get, "https://itunes.apple.com/id/lookup?id=958070620").to_return(
      headers: {'Content-Type' => 'text/html'},
      body: read_data('itunes_958070620.txt')
    )

  end

  let(:valid_attributes) {
    {
      google_play_url: 'https://play.google.com/store/apps/details?id=jp.naver.line.android&hl=id',
      itunes_url: 'https://itunes.apple.com/jp/app/line/id443904275?mt=8'
    }
  }

  let(:invalid_reverse_url_attributes) {
    {
      google_play_url: 'https://itunes.apple.com/jp/app/line/id443904275?mt=8',
      itunes_url: 'https://play.google.com/store/apps/details?id=jp.naver.line.android&hl=id'
    }
  }

  let(:invalid_both_url_attributes) {
    {
      google_play_url: 'https://play.google.com/store/apps/details?id=exampleexampleexampleexample',
      itunes_url: 'https://itunes.apple.com/id/lookup?id=0123456789'
    }
  }

  let(:invalid_itunes_url_attributes) {
    {
      google_play_url: 'https://play.google.com/store/apps/details?id=jp.co.mixi.monsterstrike&hl=ja',
      itunes_url: 'https://itunes.apple.com/id/lookup?id=0123456789'
    }
  }

  let(:invalid_google_url_attributes) {
    {
      google_play_url: 'https://play.google.com/store/apps/details?id=exampleexampleexampleexample',
      itunes_url: 'https://itunes.apple.com/jp/app/monsutasutoraiku/id658511662?mt=8'
    }
  }

  let(:invalid_attributes) {
    {
      google_play_url: nil,
      itunes_url: nil
    }
  }

  let(:invalid_csv_text){
    {
      csv_text: ''
    }
  }

  describe 'without login' do
    describe "GET #index" do
      it "redirects to login page" do
        get :index, params: {}
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe 'with login user not admin' do
    login_user

    describe "GET #index" do
      it "redirects to login page" do
        expect {
          get :index, params: {}
        }.to raise_error(ActionController::RoutingError)
      end
    end

    describe "POST #done_app" do
      context "with valid applist" do
        it "redirects to the root" do
          applist = Applist.create! valid_attributes
          UserApplist.create!(user: current_user, applist: applist)
          post :done_app, params: {applist_id: applist.id}
          expect(response).to redirect_to(root_url)
        end

        it "sets #is_done true" do
          applist = Applist.create! valid_attributes
          user_applist = UserApplist.create!(user: current_user, applist: applist)
          post :done_app, params: {applist_id: applist.id}
          user_applist.reload
          expect(user_applist.is_done).to be_truthy
        end
      end
    end

  end

  describe 'with login admin' do
    login_admin

    describe "GET #index" do
      it "assigns all applists as @applists" do
        applist = Applist.create! valid_attributes
        get :index, params: {}
        expect(assigns(:applists)).to eq([applist])
      end
    end

    describe "GET #show" do
      it "assigns the requested applist as @applist" do
        applist = Applist.create! valid_attributes
        get :show, params: {id: applist.id}
        expect(assigns(:applist)).to eq(applist)
      end
    end

    describe "GET #new" do
      it "assigns a new applist as @applist" do
        get :new, params: {}
        expect(assigns(:applist)).to be_a_new(Applist)
      end
    end

    describe "GET #edit" do
      it "assigns the requested applist as @applist" do
        applist = Applist.create! valid_attributes
        get :edit, params: {id: applist.id}
        expect(assigns(:applist)).to eq(applist)
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Applist" do
          expect {
            post :create, params: {applist: valid_attributes}
          }.to change(Applist, :count).by(1)
        end

        it "assigns a newly created applist as @applist and creates google_play_app and itunes_app" do
          post :create, params: {applist: valid_attributes}
          expect(assigns(:applist)).to be_a(Applist)
          expect(assigns(:applist)).to be_persisted
          expect(assigns(:applist).itunes_app).to be_persisted
          expect(assigns(:applist).google_play_app).to be_persisted
          expect(assigns(:applist).is_scraped).to be_truthy
        end

        it "redirects to the created applist" do
          post :create, params: {applist: valid_attributes}
          expect(response).to redirect_to(Applist.last)
        end

        it "does not create same url" do
          Applist.create! valid_attributes
          expect {
            post :create, params: {applist: valid_attributes}
          }.to change(Applist, :count).by(0)
        end
      end

      context "with reverse_url params" do
        it "assigns a newly created but unsaved applist as @applist" do
          post :create, params: {applist: invalid_reverse_url_attributes}
          expect(assigns(:applist)).to be_a_new(Applist)
        end

        it "re-renders the 'new' template" do
          post :create, params: {applist: invalid_reverse_url_attributes}
          expect(response).to render_template("new")
        end
      end

      context "with invalid_both_url_attributes params" do
        it "assigns a newly created applist but google_play_app and itunes_app are nil" do
          post :create, params: {applist: invalid_both_url_attributes}
          expect(assigns(:applist)).to be_a(Applist)
          expect(assigns(:applist)).to be_persisted
          expect(assigns(:applist).itunes_app).to be_falsey
          expect(assigns(:applist).google_play_app).to be_falsey
          expect(assigns(:applist).is_scraped).to be_falsey
        end
      end

      context "with invalid_itunes_url_attributes params" do
        it "assigns a newly created applist but google_play_app and itunes_app are nil" do
          post :create, params: {applist: invalid_itunes_url_attributes}
          expect(assigns(:applist)).to be_a(Applist)
          expect(assigns(:applist)).to be_persisted
          expect(assigns(:applist).itunes_app).to be_falsey
          expect(assigns(:applist).google_play_app).to be_falsey
          expect(assigns(:applist).is_scraped).to be_falsey
        end
      end

      context "with invalid_google_url_attributes params" do
        it "assigns a newly created applist but google_play_app and itunes_app are nil" do
          post :create, params: {applist: invalid_google_url_attributes}
          expect(assigns(:applist)).to be_a(Applist)
          expect(assigns(:applist)).to be_persisted
          expect(assigns(:applist).itunes_app).to be_falsey
          expect(assigns(:applist).google_play_app).to be_falsey
          expect(assigns(:applist).is_scraped).to be_falsey
        end
      end

      context "with invalid params" do
        it "assigns a newly created but unsaved applist as @applist" do
          post :create, params: {applist: invalid_attributes}
          expect(assigns(:applist)).to be_a_new(Applist)
        end

        it "re-renders the 'new' template" do
          post :create, params: {applist: invalid_attributes}
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {
          {
            google_play_url: 'https://play.google.com/store/apps/details?id=exampleexampleexampleexample&hl=id',
            itunes_url: 'https://itunes.apple.com/id/lookup?id=0123456789'
          }
        }

        it "updates the requested applist" do
          applist = Applist.create! valid_attributes
          put :update, params: {id: applist.id, applist: new_attributes}
          applist.reload
          expect(applist.attributes).to include new_attributes.stringify_keys
        end

        it "assigns the requested applist as @applist" do
          applist = Applist.create! valid_attributes
          put :update, params: {id: applist.id, applist: valid_attributes}
          expect(assigns(:applist)).to eq(applist)
        end

        it "redirects to the applist" do
          applist = Applist.create! valid_attributes
          put :update, params: {id: applist.id, applist: valid_attributes}
          expect(response).to redirect_to(applist)
        end
      end

      context "with invalid params" do
        it "assigns the applist as @applist" do
          applist = Applist.create! valid_attributes
          put :update, params: {id: applist.id, applist: invalid_attributes}
          expect(assigns(:applist)).to eq(applist)
        end

        it "re-renders the 'edit' template" do
          applist = Applist.create! valid_attributes
          put :update, params: {id: applist.id, applist: invalid_attributes}
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested applist" do
        applist = Applist.create! valid_attributes
        expect {
          delete :destroy, params: {id: applist.id}
        }.to change(Applist, :count).by(-1)
      end

      it "redirects to the applists list" do
        applist = Applist.create! valid_attributes
        delete :destroy, params: {id: applist.id}
        expect(response).to redirect_to(applists_url)
      end
    end

    describe "POST #scrape_app" do
      it "creates google_play_app and itunes_app" do
        applist = Applist.create! valid_attributes
        post :scrape_app, params: {applist_id: applist.id}
        applist.reload
        expect(applist.google_play_app).to be_persisted
        expect(applist.itunes_app).to be_persisted
        expect(applist.is_scraped).to be_truthy
      end

      it "does not save google_play_app and itunes_app if applist urls are invalid" do
        applist = Applist.create! invalid_both_url_attributes
        post :scrape_app, params: {applist_id: applist.id}
        expect(applist.google_play_app).to be_falsey
        expect(applist.itunes_app).to be_falsey
        expect(applist.is_scraped).to be_falsey
      end

      it "redirects to the applists" do
        applist = Applist.create! valid_attributes
        post :scrape_app, params: {applist_id: applist.id}
        expect(response).to redirect_to(applists_url)
      end
    end

    describe "POST #import" do
      context "with valid params" do
        before do
          @csv_text = <<EOL
https://play.google.com/store/apps/details?id=com.space.japanese&hl=en,
https://play.google.com/store/apps/details?id=com.maxmpz.audioplayer.unlock,
https://play.google.com/store/apps/details?id=com.NeverEndingMedia.HTMC&hl=in,https://itunes.apple.com/mx/app/hey!-thats-my-cheese/id1040204246?l=en&mt=8
,https://itunes.apple.com/id/app/the-king-of-fighters-i-2012-f/id958070620?mt=8
EOL
          @duplicated_csv_text = <<EOL
https://play.google.com/store/apps/details?id=jp.naver.line.android&hl=id,https://itunes.apple.com/jp/app/line/id443904275?mt=8
https://play.google.com/store/apps/details?id=jp.naver.line.android&hl=id,https://itunes.apple.com/jp/app/line/id443904275?mt=8
https://play.google.com/store/apps/details?id=jp.naver.line.android&hl=id,https://itunes.apple.com/jp/app/line/id443904275?mt=8
EOL
        end

        it "creates 4 new Applist" do
          expect {
            post :import, params: {csv_text: @csv_text}
          }.to change(Applist, :count).by(4)
        end

        it "assigns a created app detail count as @scrape_success_count" do
          post :import, params: {csv_text: @csv_text}
          expect(assigns(:applists).count).to eq(4)
          expect(assigns(:scrape_success_count)).to eq(4)
        end

        it "redirects to the applists if params is blank" do
          post :import
          expect(response).to redirect_to(applists_url)
        end

        it "skips duplicated rows" do
          expect {
            post :import, params: {csv_text: @duplicated_csv_text}
          }.to change(Applist, :count).by(1)
        end

        it "skips duplicated rows and assigns a created app detail count as @scrape_success_count" do
          post :import, params: {csv_text: @duplicated_csv_text}
          expect(assigns(:applists).count).to eq(1)
          expect(assigns(:scrape_success_count)).to eq(1)
        end

        it "redirects to applists" do
          post :import, params: {csv_text: @csv_text}
          expect(response).to redirect_to(applists_url)
        end
      end
    end

    describe "POST #done_app" do
      context "with valid applist" do
        it "redirects to the root" do
          applist = Applist.create! valid_attributes
          UserApplist.create!(user: current_user, applist: applist)
          post :done_app, params: {applist_id: applist.id}
          expect(response).to redirect_to(root_url)
        end

        it "sets #is_done true" do
          applist = Applist.create! valid_attributes
          user_applist = UserApplist.create!(user: current_user, applist: applist)
          post :done_app, params: {applist_id: applist.id}
          user_applist.reload
          expect(user_applist.is_done).to be_truthy
        end
      end
    end
  end
end
