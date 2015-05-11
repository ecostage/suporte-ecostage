require 'spec_helper'

describe Robot, :vcr do
  describe '#retrieve' do
    it 'retrieves the robot user' do
      robot = Robot.retrieve
      expect(robot).to be_kind_of(User)
      expect(robot.user_type).to eq('robot')
      expect(robot.persisted?).to be_truthy
    end
  end
end
