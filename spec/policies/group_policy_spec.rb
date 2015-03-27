require 'rspec'

describe GroupPolicy do
  describe '#new?' do
    context 'a client tries to create a group' do
      it 'returns false' do
        current_user = double('User', admin?: false)
        group = double
        group_policy = GroupPolicy.new(current_user, group)
        expect(group_policy.new?).to eq(false)
      end
    end

    context 'an admin tries to create a group' do
      it 'returns true' do
        current_user = double('User', admin?: true)
        group = double
        group_policy = GroupPolicy.new(current_user, group)
        expect(group_policy.new?).to eq(true)
      end
    end
  end

  describe '#index?' do
    context 'a client tries to see all groups' do
      it 'returns false' do
        current_user = double('User', admin?: false)
        group = double
        group_policy = GroupPolicy.new(current_user, group)
        expect(group_policy.new?).to eq(false)
      end
    end

    context 'an admin tries to see all groupsp' do
      it 'returns true' do
        current_user = double('User', admin?: true)
        group = double
        group_policy = GroupPolicy.new(current_user, group)
        expect(group_policy.new?).to eq(true)
      end
    end
  end
end
