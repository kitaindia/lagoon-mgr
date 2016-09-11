Module.new do
  def login_user
    if block_given?
      let(:current_user) { yield }
    else
      let(:current_user) { FactoryGirl.create(:user) }
    end

    before do
      controller.sign_in current_user
    end
  end

  def login_admin
    login_user do
      FactoryGirl.create(:user, :admin)
    end
  end

  RSpec.configure do |config|
    config.include Devise::Test::ControllerHelpers, type: :controller
    config.extend self, type: :controller
  end
end
