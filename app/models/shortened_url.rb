class ShortenedUrl < ActiveRecord::Base
	belongs_to :user

	def self.encode(input)
		input.to_s(36)
	end

	def self.decode(input)
		input.to_i(36)
	end

end

