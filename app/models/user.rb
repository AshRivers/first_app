# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
	attr_accessor :password
  	attr_accessible :email, :name, :password, :password_confirmation, :encrypted_password

    has_many :microposts, :dependent => :destroy
    has_many :relationships,  foreign_key: "follower_id", 
                              dependent: :destroy 
    has_many :following, through: :relationships, source: :followed

    has_many :reverse_relationships,  foreign_key: "followed_id", 
                                      dependent: :destroy,
                                      class_name: "Relationship"
    has_many :followers, through: :reverse_relationships, source: :follower

  	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  	validates :name, 	presence: true,
  						length: {maximum: 50}
  	validates :email, 	presence: true,
  						format: {with: email_regex},
  						uniqueness: {case_sensitive: false}
  	validates :password, 	presence: true,
  							confirmation: true,
  							length: {within: 6..23}

  	before_save :encrypt_pass

    def has_password?(submitted_pass)
      encrypted_password == encrypt(submitted_pass)
    end

    def self.authentificate(email, pass)
      user = find_by_email(email)
      return nil if user.nil?
      return user if user.has_password?(pass)
    end

    def self.authentificate_with_salt(id, cookie_salt)
      user = find_by_id(id)
      (user && user.salt ==cookie_salt ) ? user : nil
    end

    def feed 
      Micropost.from_users_followed_by(self)
    end

    def follow!(followed)
      self.relationships.create(followed_id: followed.id)
    end

    def unfollow!(followed)
      self.relationships.find_by_followed_id(followed).destroy
    end

    def following?(followed)
      self.relationships.find_by_followed_id(followed)
    end

  	private 

  		def encrypt_pass
        self.salt = make_salt if self.new_record?
  			self.encrypted_password = encrypt(password)
  		end

      def make_salt
        hashing("#{Time.now.utc}")
      end

  		def encrypt(pass)
  			hashing("#{self.salt}-#{pass}")
  		end

      def hashing(string)
        Digest::SHA2.hexdigest(string)
      end


end
