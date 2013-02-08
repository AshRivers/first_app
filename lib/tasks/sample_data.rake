namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_mp
    make_rs

  end
end

def make_users
  admin = User.create!(:name => "Example User",
               :email => "example@railstutorial.org",
               :password => "foobar123",
               :password_confirmation => "foobar123")
  admin.toggle!(:admin)

  36.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(:name => name,
                 :email => email,
                 :password => password,
                 :password_confirmation => password)
  end
end

def make_mp
  User.all(limit: 6).each do |user|
    50.times do 
      user.microposts.create(content: Faker::Lorem.sentence(3))
    end
  end
end

def make_rs
  users = User.all
  user  = users.first
  following = users[1..50]
  followers = users[3..40]
  following.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end