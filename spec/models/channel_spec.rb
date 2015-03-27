require 'spec_helper'

describe Channel do
  let(:general) { FactoryGirl.create(:general) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:ticket) { FactoryGirl.create(:ticket) }

  describe 'associations' do
    it { should_not have_many(:tickets).through(:channel_tickets) }
    it { should have_many(:tickets) }
  end

  it "title should be unique" do
    general
    new_general = FactoryGirl.build(:general)
    expect(new_general.valid?).to eq(false)
  end

  it "should build new member" do
    general.new_member(admin)
    expect(general.members).to eq([admin])
  end

  it "should create a ticket" do
    general.add_ticket(ticket)
    expect(general.tickets).to eq([ticket])
  end
end
