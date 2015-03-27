require 'rails_helper'

RSpec.describe Notifiable, :type => :model do

  let(:notifiable) { TestNotifiable.new(attendant) }
  let(:attendant) { create(:attendant) }

  class TestNotifiable
    include Notifiable

    recipients_for :ticket_created do
      [@attendant]
    end

    context_for :ticket_created do
      {
        attendant: @attendant
      }
    end

    def initialize(attendant)
      @attendant = attendant
    end
  end

  it 'recipients for action' do
    expect(notifiable.recipients_for(:ticket_created)).to eq([attendant])
  end

  it 'contexts for action' do
    expect(notifiable.context_for(:ticket_created)).to eq({ attendant: attendant })
  end
end
