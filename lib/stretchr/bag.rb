require "uri"

module Stretchr
	# Bag is a general parameter holder with
	# special functions for converting a hash into
	# a query string for Stretchr
	class Bag
		def initialize(options = {})
			@params = {} # the general param hash
			@prefix = options[:prefix] # the prefix added to every key before saving
		end

		# Set will store a value for a given key
		# ==== Parameters
		# +param+ - The key to store the value under
		# +value+ - The value to store under that key, will always overwrite, so send an array for multiples
		#
		# ==== Examples
		# s = Stretchr::Bag.new
		# s.set("key", "value")
		# s.get("key") #=> "value"
		def set(param, value = nil)
			if param.is_a?(Hash)
				param.each_pair do |k, v|
					set(k, v)
				end
			else
				param = "#{@prefix}#{param}" if @prefix
				@params[param.to_s] = value unless value == nil
			end
		end

		# Get will retrieve a stored value
		# ==== Parameters
		# +param+ - The key to retrieve the values for
		#
		# ==== Examples
		# s = Stretchr::Bag.new
		# s.set("key", "value")
		# s.get("key") #=> "value"
		def get(param)
			param = "#{@prefix}#{param}" if @prefix
			@params[param.to_s]
		end

		# Returns a url encoded query string of the current stored
		# values
		#
		# ==== Examples
		# s = Stretchr::Bag.new
		# s.set("key", "value")
		# s.set("key2", ["value1", "value2"])
		# s.query_string #=> "key=value&key2=value1&key2=value2"
		def query_string
			URI.encode_www_form(@params)
		end
	end
end