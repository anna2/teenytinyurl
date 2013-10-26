class User <ActiveRecord::Base
	has_many :shortened_urls, dependent: :destroy


	def self.retrieve_urls
	end

	def self.encode(password)
		Digest::MD5.hexdigest(password)
	end

end