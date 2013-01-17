# Используя символ ':user', мы указываем Factory Girl на необходимость симулировать модель User.
FactoryGirl.define do 
	factory :user, :class => User do
  		name                  "Michael Hartl"
  		email                 "mhartl@example.com"
 		password              "foobar_bar"
 		 password_confirmation "foobar_bar"
	end
end