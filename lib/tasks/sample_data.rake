namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "Paul Famiglietti",
                 username: "pjfamig",
                 email: "pjfamig@gmail.com",
                 password: "fr0gger5",
                 admin: true,
                 superadmin: true)
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      username = "example#{n+1}"
      password  = "password"
      User.create!(name: name,
                   username: username,
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