FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "sample#{n}" }
    sequence(:email)        { |n| "sample#{n}@sample.com" }
    password                { 'password' }
    password_confirmation   { 'password' }
    confirmed_at            { Time.now }
  end

  trait :guest do
    name     { 'guest_user' }
    email    { 'try.rhtme.ddr@gmail.com' }
    password { 'password' }
    confirmed_at { Time.now }
  end

end
