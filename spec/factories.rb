FactoryGirl.define do
  factory :user do
    name     "Paul Famiglietti"
    email    "pjfamig@ucla.edu"
    password "foobar"
    password_confirmation "foobar"
  end
end