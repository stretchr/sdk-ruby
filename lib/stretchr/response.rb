require "json"
module Stretchr
	class Response
		attr_reader :raw, :parsed
		def initialize(response)
			@raw = response
			@parsed = JSON.parse(response)
		end

		def success?
			@parsed["~status"] >= 200 && @parsed["~status"] <= 299
		end
	end
end