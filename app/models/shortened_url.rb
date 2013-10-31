class ShortenedUrl < ActiveRecord::Base
	belongs_to :user

	def self.encode(input)
		input.to_s(36)
	end

	def self.decode(input)
		input.to_i(36)
	end

	def self.get_from_hex(hex)
		ShortenedUrl.find(decode(hex))
	end

end

class InvalidID < StandardError
end