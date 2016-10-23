require 'rails_helper'

RSpec.describe Applist, type: :model do

  before do

    stub_request(:get, %r{https://play\.google\.com/store/apps/details\?gl=us&hl=en&id=exampleexampleexampleexample\Z}).to_return(
      headers: {'Content-Type' => 'text/html'},
      body: read_data('google_exampleexampleexampleexample.txt')
    )

    stub_request(:get, %r{https://play\.google\.com/store/apps/details\?gl=us&hl=en&id=com\.kakao\.talk\Z}).to_return(
      headers: {'Content-Type' => 'text/html'},
      body: read_data('google_com.kakao.talk.txt')
    )

    stub_request(:get, "https://itunes.apple.com/in/lookup?id=0123456789").to_return(
      headers: {'Content-Type' => 'text/html'},
      body: read_data('itunes_0123456789.txt')
    )

    stub_request(:get, "https://itunes.apple.com/in/lookup?id=362057947").to_return(
      headers: {'Content-Type' => 'text/html'},
      body: read_data('itunes_362057947.txt')
    )

  end

  describe "scrape_app method" do
    context "valid google_play_url and valid itunes_url" do
      it "creates google_play_app and itunes_app" do
        applist = FactoryGirl.create(:applist)
        expect(applist.scrape_app).to be_truthy
        expect(applist.itunes_app).to be_persisted
        expect(applist.google_play_app).to be_persisted
        expect(applist.is_scraped).to be_truthy
      end
    end

    context "blank google_play_url and valid itunes_url" do
      it "creates itunes_app only" do
        applist = FactoryGirl.create(:applist, :without_google_play_url)
        expect(applist.scrape_app).to be_truthy
        expect(applist.itunes_app).to be_persisted
        expect(applist.google_play_app).to be_falsey
        expect(applist.is_scraped).to be_truthy
      end
    end

    context "valid google_play_url and blank itunes_url" do
      it "creates google_play only" do
        applist = FactoryGirl.create(:applist, :without_itunes_url)
        expect(applist.scrape_app).to be_truthy
        expect(applist.itunes_app).to be_falsey
        expect(applist.google_play_app).to be_persisted
        expect(applist.is_scraped).to be_truthy
      end
    end

    context "Not Founded google_play_url's url and Not Founded itunes_url's url" do
      it "deos not create google_play_app and itunes_app" do
        applist = FactoryGirl.create(:applist, :with_invalid_google_play_url, :with_invalid_itunes_url)
        expect(applist.scrape_app).to be_falsey
        expect(applist.itunes_app).to be_falsey
        expect(applist.google_play_app).to be_falsey
      end
    end

    context "Not Founded google_play_url's url and valid itunes_url" do
      it "does not create either" do
        applist = FactoryGirl.create(:applist, :with_invalid_google_play_url)
        expect(applist.scrape_app).to be_falsey
        expect(applist.itunes_app).to be_falsey
        expect(applist.google_play_app).to be_falsey
        expect(applist.is_scraped).to be_falsey
      end
    end

    context "valid google_play_url and Not Founded itunes_url's url" do
      it "does not create either" do
        applist = FactoryGirl.create(:applist, :with_invalid_itunes_url)
        expect(applist.scrape_app).to be_falsey
        expect(applist.itunes_app).to be_falsey
        expect(applist.google_play_app).to be_falsey
        expect(applist.is_scraped).to be_falsey
      end
    end
  end
end
