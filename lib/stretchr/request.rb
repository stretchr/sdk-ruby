require "uri"

module Stretchr
	# The request class is where most of the url building magic takes place
	# It collects all methods passed to it and uses them to build a url for you
	class Request
		attr_accessor :base_url, :api_version
		def initialize(options = {})
			@path_elements = []
			self.base_url = options[:base_url] || ""
			self.api_version = options[:api_version] || ""
		end

		# Returns the current path that the request is working with
		#
		# ==== Examples
		# r = Stretchr::Request.new
		# r.people(1).cars.path #=> "people/1/cars"
		def path
			@path_elements.join("/")
		end

		# Returns the full url, including the path for the current request
		def to_url
			to_uri.to_s
		end

		# Builds a URI object
		def to_uri
			URI::HTTPS.build(host: base_url, path: merge_path)
		end

		# Catch everyting not defined and turn it into url parameters
		# If you include an argument, it will be passed into the url as the ID for the
		# collection you specified in the method name
		#
		# ==== Examples
		# r = Stretchr::Request.new
		# r.people(1).cars.path #=> "people/1/cars"
		def method_missing(method, *args)
			@path_elements << method.to_s
			@path_elements << args[0] if args[0]
			return self
		end

		private

		def merge_path
			"/api/#{api_version}/#{@path_elements.join('/')}"
		end
	end
end