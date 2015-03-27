# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :member, class: 'User' do
    name "Member"
    email "member@tracersoft.com.br"
    password "tracersoft"
    user_type :attendant
  end

  factory :admin, class: 'User' do
    name "Admin"
    email "admin@tracersoft.com.br"
    password 'tracersoft'
    user_type :admin
  end

  factory :client, aliases: [:user], class: 'User' do
    name "Client"
    sequence(:email) { |n| "client#{n}@tracersoft.com.br" }
    password 'tracersoft'
    user_type :client

    trait :with_channels do
      ignore do
        channels_count 3
      end

      after :create do |client, evaluator|
        create_list(:channel, evaluator.channels_count, members: [ client ])
      end
    end

    trait :related_with_groups do
      ignore do
        groups_count 3
      end

      after :create do |client, evaluator|
        create_list(:group, evaluator.groups_count, members: [ client ], channels: create_list(:channel, 2) )
      end
    end
  end

  factory :attendant, class: 'User' do
    name "Attendant"
    sequence(:email) { |n| "attendant#{n}@tracersoft.com.br" }
    password 'tracersoft'
    user_type :attendant
  end
end
