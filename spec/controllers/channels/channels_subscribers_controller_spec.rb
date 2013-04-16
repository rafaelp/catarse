require 'spec_helper'

describe Channels::ChannelsSubscribersController do
  subject{ response }
  let(:channel_subscriber){ ChannelsSubscriber.create!(channel: channel, user: user) }
  let(:channel){ FactoryGirl.create(:channel) }
  let(:user){ FactoryGirl.create(:user) }
  let(:current_user){ user }

  before do
    request.stubs(:subdomain).returns(channel.permalink)
    controller.stubs(:current_user).returns(current_user)
  end

  describe "POST create" do
    before do
      post :create
    end

    context "when user is signed in" do 
      it{ should redirect_to root_path }
    end

    context "when no user is signed in" do 
      let(:current_user){ nil }
      it{ should redirect_to new_user_session_path }
    end
  end

  describe "DELETE destroy" do
    before do
      delete :destroy, id: channel_subscriber.id
    end

    context "when signed in user owns the subscription" do
      it{ should redirect_to root_path }
    end

    context "when signed in user does not own the subscription" do
      let(:current_user){ FactoryGirl.create(:user) }
      it{ should_not be_successful }
    end
  end
end
