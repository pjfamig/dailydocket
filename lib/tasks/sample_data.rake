namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "",
                 username: "",
                 email: "",
                 password: "",
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