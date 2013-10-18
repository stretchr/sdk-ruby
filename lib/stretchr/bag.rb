require "uri"

module Stretchr
	class Bag
		def initialize
			@params = {}
		end

		def set(param, value)
			@params[param] = value
		end

		def get(param)
			@params[param]
		end

		def query_string
			URI.encode_www_form(@params)
		end
	end
end