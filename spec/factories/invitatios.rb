FactoryGirl.define do
  factory :invitation do
    after :create do |invitation, evaluator|
      invitation.user = create(:user)
    end
  end
end
