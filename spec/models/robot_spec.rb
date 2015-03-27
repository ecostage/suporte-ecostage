require 'spec_helper'

describe Robot, :vcr do
  describe '#retrieve' do
    context 'ROBOT_ENV is set' do
      before do
        ENV['ROBOT_EMAIL'] = 'robot@tracersoft.com.br'
      end

      it { expect { Robot.retrieve }.not_to raise_error }
    end

    context 'ROBOT_EMAIL env not set' do
      before do
        ENV['ROBOT_EMAIL'] = nil
      end
      it { expect { Robot.retrieve }.to raise_error }
    end

    it 'retrieves the robot user' do
      robot = Robot.retrieve
      expect(robot).to be_kind_of(User)
      expect(robot.user_type).to eq('robot')
      expect(robot.persisted?).to be_truthy
    end
  end
end
