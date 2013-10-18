module Stretchr
	class Response
		attr_reader :raw
		def initialize(response)
			@raw = response
		end
	end
end