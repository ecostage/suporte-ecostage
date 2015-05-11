# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ticket, aliases: [:unread_ticket] do
    subject "Ticket subject"
    content "Ticket content"
    is_priority false
    estimated_time 5
    complexity 1
    resolved_at "2014-09-17 12:12:23"
    attended_at "2014-09-17 12:12:23"
    association :created_by, factory: :client
    association :channel, factory: :channel

    Ticket.statuses.each do |status, _|
      trait status.to_sym do
        status status
      end
    end
  end
end
