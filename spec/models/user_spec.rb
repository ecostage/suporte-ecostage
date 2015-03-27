require 'spec_helper'

describe User do
  describe '#status' do
    context 'a new user' do
      it 'returns active' do
        expect(User.new.status).to eq 'active'
      end
    end
  end

  describe 'client should be the default' do
    it 'returns a client user' do
      user = User.new
      expect(user.client?).to be true
    end
  end

  describe 'as_recipient' do
    it 'returns the user as a email recipient' do
      user = create(:client)
      expect(user.as_recipient).to include(user.email)
      expect(user.as_recipient).to include(user.name)
    end
  end

  describe 'siblings' do
    it 'returns users from same group' do
      client1 = create(:client)
      client2 = create(:client)
      client3 = create(:client)

      group = create(:group)

      group.members << client1
      group.members << client2


      expect(client1.siblings).to contain_exactly(client1, client2)
      expect(client2.siblings).to contain_exactly(client1, client2)
      expect(client3.siblings).to contain_exactly(client3)
    end
  end

  describe '#user_type' do
    context 'creating a client' do
      it 'returns a client' do
        client = User.new(user_type: :client)
        expect(client.user_type).to eq('client')
      end
    end
    context 'creating a attendant' do
      it 'returns a client' do
        member = User.new(user_type: :attendant)
        expect(member.user_type).to eq('attendant')
      end
    end
    context 'creating a admin' do
      it 'returns a admin' do
        member = User.new(user_type: :admin)
        expect(member.user_type).to eq('admin')
      end
    end
  end
end
