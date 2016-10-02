require 'rails_helper'

RSpec.describe Applist, type: :model do
  describe "scrape_app method" do
    context "valid google_play_url and valid itunes_url" do
      it "creates google_play_app and itunes_app" do
        applist = FactoryGirl.create(:applist, :valid)
        expect(applist.scrape_app).to be_truthy
        expect(applist.itunes_app).to be_persisted
        expect(applist.google_play_app).to be_persisted
        expect(applist.is_scraped).to be_truthy
      end
    end

    context "blank google_play_url and valid itunes_url" do
      it "creates itunes_app only" do
        applist = FactoryGirl.create(:applist, :blank_google_play_url)
        expect(applist.scrape_app).to be_truthy
        expect(applist.itunes_app).to be_persisted
        expect(applist.google_play_app).to be_falsey
        expect(applist.is_scraped).to be_truthy
      end
    end

    context "valid google_play_url and blank itunes_url" do
      it "creates itunes_app only" do
        applist = FactoryGirl.create(:applist, :blank_itunes_url)
        expect(applist.scrape_app).to be_truthy
        expect(applist.itunes_app).to be_falsey
        expect(applist.google_play_app).to be_persisted
        expect(applist.is_scraped).to be_truthy
      end
    end

    context "Not Founded google_play_url's url and Not Founded itunes_url's url" do
      it "deos not create google_play_app and itunes_app" do
        applist = FactoryGirl.create(:applist, :invalid)
        expect(applist.scrape_app).to be_falsey
        expect(applist.itunes_app).to be_falsey
        expect(applist.google_play_app).to be_falsey
      end
    end

    context "Not Founded google_play_url's url and valid  itunes_url" do
      it "does not create either" do
        applist = FactoryGirl.create(:applist, :invalid_google_play_url)
        expect(applist.scrape_app).to be_falsey
        expect(applist.itunes_app).to be_falsey
        expect(applist.google_play_app).to be_falsey
        expect(applist.is_scraped).to be_falsey
      end
    end

    context "valid google_play_url and Not Founded itunes_url's url" do
      it "does not create either" do
        applist = FactoryGirl.create(:applist, :invalid_itunes_url)
        expect(applist.scrape_app).to be_falsey
        expect(applist.itunes_app).to be_falsey
        expect(applist.google_play_app).to be_falsey
        expect(applist.is_scraped).to be_falsey
      end
    end
  end
end
