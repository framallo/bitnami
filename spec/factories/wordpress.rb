FactoryGirl.define do
  factory :wordpress do
    user

    factory :wordpress_with_instance do
      instance_id 'i-1abc1234'
    end

    factory :wordpress_without_credentials do
      association :user, factory: :user_without_credentials
    end
  end
end
