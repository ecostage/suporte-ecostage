require 'rspec'

describe ChannelPolicy do
  describe '#new?' do
    context 'a client tries to access /channels/new' do
      it 'returns false' do
        current_user = double('User', client?: true)
        channel = double
        channel_policy = ChannelPolicy.new(current_user, channel)
        expect(channel_policy.new?).to eq(false)
      end
    end
  end

  describe '#edit?' do
    context 'a client tries to access /channels/:id/edit' do
      it 'returns false' do
        current_user = double('User', client?: true)
        channel = double
        channel_policy = ChannelPolicy.new(current_user, channel)
        expect(channel_policy.edit?).to eq(false)
      end
    end
  end

  describe '#destroy?' do
    context 'a client tries to delete /channels/:id' do
      it 'returns false' do
        current_user = double('User', client?: true)
        channel = double
        channel_policy = ChannelPolicy.new(current_user, channel)
        expect(channel_policy.destroy?).to eq(false)
      end
    end

    describe '#index?' do
      context 'a client tries to visit /channels' do
        it 'returns false' do
          current_user = double('User', client?: true)
          channel = double
          channel_policy = ChannelPolicy.new(current_user, channel)
          expect(channel_policy.index?).to eq(false)
        end
      end
    end

    describe '#show?' do
      context 'a client tries to visit /channels/:id' do
        it 'returns true' do
          group = double('Group')
          channel = double('Channel', groups: [group])
          current_user = double('User', client?: true,
                                admin?: false, attendant?: false, group: group)
          channel_policy = ChannelPolicy.new(current_user, channel)
          expect(channel_policy.show?).to eq(true)
        end

      end

      context 'a admin/attendant tries to visit /channels/:id' do
        it 'returns true' do
          current_user = double('User', admin?: true, attendant?: false)
          channel = create :channel
          channel_policy = ChannelPolicy.new(current_user, channel)
          expect(channel_policy.show?).to eq(true)
        end

        it 'returns true' do
          current_user = double('User', attendant?: true)
          channel = create :channel
          channel_policy = ChannelPolicy.new(current_user, channel)
          expect(channel_policy.show?).to eq(true)
        end
      end
    end

    describe '#update?' do
      context 'a client tries to update /channels/:id' do
        it 'returns false' do
          current_user = double('User', client?: true)
          channel = double
          channel_policy = ChannelPolicy.new(current_user, channel)
          expect(channel_policy.update?).to eq(false)
        end
      end

      context 'a admin/attedant tries to update /channels/:id' do
        it 'returns true' do
          current_user = double('User', client?: false)
          channel = double
          channel_policy = ChannelPolicy.new(current_user, channel)
          expect(channel_policy.update?).to eq(true)
        end
      end
    end
  end
end
