# Используя символ ':user', мы указываем Factory Girl на необходимость симулировать модель User.
FactoryGirl.define do 
	factory :user do
  		name                  "Michael Hartl"
  		email                 "mhartl@example.com"
 		password              "foobar_bar"
 		password_confirmation "foobar_bar"
	end

	sequence :email do |n|
		"person-#{n}@example.com"
	end

	factory :micropost do
		content = "some useless content"
		user
	end

end
