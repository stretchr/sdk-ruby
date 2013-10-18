require "uri"

module Stretchr
	class Bag
		def initialize(options = {})
			@params = {}
			@prefix = options[:prefix]
		end

		def set(param, value)
			param = "#{@prefix}#{param}" if @prefix
			@params[param] = value
		end

		def get(param)
			param = "#{@prefix}#{param}" if @prefix
			@params[param]
		end

		def query_string
			URI.encode_www_form(@params)
		end
	end
end