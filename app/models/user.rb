class User <ActiveRecord::Base
	has_many :shortened_urls, dependent: :destroy
	validates :username, uniqueness: true

	def self.encode(password)
		Digest::MD5.hexdigest(password)
	end

	def self.signup(username, password)
		if User.exists?(username: username)
			raise TakenUsername
		elsif password.empty?
			raise InvalidNewPassword
		end
		encoded_password = encode(password)
		User.create(username: username, password_hash: encoded_password)
	end

	def self.login(username, password)
		if User.exists?(username: username) == false
			raise NonexistentUsername
		elsif User.encode(password) != User.find_by(username: username).password_hash
			raise NonmatchingPassword
		end
		User.find_by(username: username)
	end
	
end

class TakenUsername < StandardError
end

class InvalidNewPassword < StandardError
end

class NonexistentUsername < StandardError
end

class NonmatchingPassword < StandardError
end