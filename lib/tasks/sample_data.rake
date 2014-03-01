namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "Paul Famiglietti",
                 email: "pjfamig@gmail.com",
                 password: "fr0gger5",
                 password_confirmation: "fr0gger5",
                 admin: true)
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
    
    users = User.all(limit: 6)
    50.times do
      headline = Faker::Lorem.sentence(5)
      url = "http://paulfamiglietti.com"
      users.each { |user| user.posts.create!(headline: headline, url: url) }
    end
  end
end