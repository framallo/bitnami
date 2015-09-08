FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    name 'John Doe'
    password '12345Abc'
    password_confirmation '12345Abc'

    factory :user_with_aws do
      aws_access_key_id '12345'
      aws_secret_access_key '12345'
    end
  end

end
