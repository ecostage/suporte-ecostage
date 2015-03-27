# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :channel do
    sequence(:name) { |n| "Channel_#{n}" }

    factory :channel_with_tickets, class: 'Channel' do
      after :create do |channel|
        channel.tickets << create(:ticket)
      end
    end

    factory :channel_with_members, class: 'Channel' do
      after :create do |channel|
        channel.members << create(:member)
      end
    end
  end

  factory :general, :class=>Channel do
    name "General"
    purpose "General purpose communication channel"
  end
end
