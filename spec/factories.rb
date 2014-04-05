FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "user_#{n}" }
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"
    
    factory :admin do
      admin true
    end
    
    factory :superadmin do
      admin true
      superadmin true
    end
  end
  
  factory :post do
    headline "Lorem ipsum"
    url "http://paulfamiglietti.com"
    user
  end
  
  factory :comment do
    content "Lorem ipsum"
    user
    post
  end
end