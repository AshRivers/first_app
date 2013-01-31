namespace :db do
  desc "Fill database with sample data"
  task :populateadmin => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:name => "Example User",
                 :email => "example@railstutorial.org",
                 :password => "foobar123",
                 :password_confirmation => "foobar123")
    admin.toggle!(:admin)
    
  end

  task :populate => :environment do

    5.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(:name => name,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
    end
  end
end
