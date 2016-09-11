require 'rails_helper'

RSpec.describe ApplistsController, type: :controller do
  let(:valid_attributes) {
    {
      google_play_url: 'https://play.google.com/store/apps/details?id=test.lagoon-mgr&hl=id',
      itunes_url: 'https://itunes.apple.com/id/lookup?id=123456789'
    }
  }

  let(:invalid_attributes) {
    {
      google_play_url: nil,
      itunes_url: nil
    }
  }

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

      it "assigns a newly created applist as @applist" do
        post :create, params: {applist: valid_attributes}
        expect(assigns(:applist)).to be_a(Applist)
        expect(assigns(:applist)).to be_persisted
      end

      it "redirects to the created applist" do
        post :create, params: {applist: valid_attributes}
        expect(response).to redirect_to(Applist.last)
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
          google_play_url: 'https://play.google.com/store/apps/details?id=test.lagoon-mgr.new&hl=id',
          itunes_url: 'https://itunes.apple.com/id/lookup?id=987654321'
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

end
