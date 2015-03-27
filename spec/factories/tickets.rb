# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ticket, aliases: [:unread_ticket] do
    subject "Ticket subject"
    content "Ticket content"
    is_priority false
    estimated_time 1
    complexity 1
    resolved_at "2014-09-17 12:12:23"
    attended_at "2014-09-17 12:12:23"
    association :created_by, factory: :client
    association :channel, factory: :channel

    factory :approved_ticket do
      status :approved
    end

    factory :reproved_ticket do
      status :reproved
    end

    factory :in_progress_ticket do
      status :in_progress
    end

    factory :done_ticket do
      status :done
    end
  end
end
