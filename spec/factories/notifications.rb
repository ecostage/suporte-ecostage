# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification do
    notifiable nil
    created_by nil
    action "MyString"

    factory :ticket_created_notification do
      association :notifiable, factory: :ticket
      association :created_by, factory: :client
      action :created
    end
  end
end
