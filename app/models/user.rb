class User <ActiveRecord::Base
	has_many :shortened_urls, dependent: :destroy
	validates :username, uniqueness: true
	validates :username, length: { in: 2..30 }

	def self.encode(password)
		Digest::MD5.hexdigest(password)
	end

	def self.signup(username, password)
		if User.exists?(username: username)
			raise ExistingUsername
		elsif (username.size < 2) || (username.size > 30)
			raise InvalidUsername
		elsif password.empty? || password.nil?
			raise InvalidNewPassword
		else
			encoded_password = encode(password)
			User.create(username: username, password_hash: encoded_password)
		end
	end

	def self.login(username, password)
		if User.exists?(username: username) == nil
			raise NonexistentUsername
		elsif User.encode(password) != User.find_by(username: username).password_hash
			raise NonmatchingPassword
		else
			User.find_by(username: username)
		end
	end
	
end

class ExistingUsername < StandardError
end

class InvalidUsername < StandardError
end

class InvalidNewPassword < StandardError
end

class NonexistentUsername < StandardError
end

class NonmatchingPassword < StandardError
end