require 'spec_helper'

describe Group do
  describe 'associations' do
    it { should have_many(:members) }
    it { should have_many(:group_channels) }
    it { should have_many(:channels).through(:group_channels) }
  end

  describe '#invite' do
    it 'delegates the invitation to invite model' do
      group = create(:group)
      inviter = create(:attendant)
      email = 'new_invited_user@example.org'
      invitation = double
      allow(Invitation).to receive(:invite).with(hash_including(email: email, sender: inviter, group_id: group.id, user_type: :client)) { invitation }

      invited= group.invite(email, inviter)
      expect(invited).to eq invitation
    end
  end
end
