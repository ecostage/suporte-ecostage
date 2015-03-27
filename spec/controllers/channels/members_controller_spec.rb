require 'spec_helper'

RSpec.describe Channels::MembersController, :type => :controller do
  let(:admin) {
    FactoryGirl.create(:admin)
  }

  let(:general) {
    FactoryGirl.create(:general)
  }

  let(:member) {
    FactoryGirl.create(:channel_member)
  }

  let(:valid_session) { {} }

  describe "POST create" do
    it "inserts a member in a channel" do
      expect {
        post :create, { :format=>:json, :channel_id => general.to_param, :user_id => admin.to_param }, valid_session
      }.to change(general.members, :count).by(1)
    end
  end

  #describe "DELETE destroy" do
  #  it "removes a member from a channel" do
  #    expect {
  #      delete :destroy, { :format=>:json, :channel_id => general.to_param, :id => member.to_param }, valid_session
  #    }.to change(general.members, :count).by(-1)
  #  end
  #end
end
