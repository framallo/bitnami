FactoryGirl.define do
  factory :user_without_credentials, class: User do
    email { Faker::Internet.email }
    name 'John Doe'
    password '12345Abc'
    password_confirmation '12345Abc'

    factory :user do
      before(:create) do |user|
        user.aws_access_key_id = 'AAAAAAAAAAAAAAAAAAAA'
        user.aws_secret_access_key = '1aA11A/aaAAAaAAaaAAaaaa1aaAa1aaa1AAaaa11'
      end
    end
  end
end
