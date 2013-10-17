module Stretchr
	class Client
		attr_accessor :transporter, :api_version, :project, :key
		# Initializes a new stretchr client
		# This is the main entrypoint into working with stretchr
		#
		# ==== Paramters
		# +options[:project]+ - The project you're working with
		# +options[:key]+ - The key for the project you want to use
		# +options[:transporter]+ - The transporter to use for actually making requests
		# +options[:api_version]+ - The stretchr API endpoint we want to communicate with
		def initialize(options = {})
			self.transporter = options[:transporter]
			self.api_version = options[:api_version] || "v1.1"
			self.project = options[:project]
			self.key = options[:key]
		end

		# Catches everything you can throw at client and passes it on to a new request object
		# All interactions will then take place on the request object itself
		# This is the primary function of the Client class, to get you into 
		# a unique request as quickly as possible
		#
		# ==== Example
		# stretchr = Stretchr::Client.new({project: "project", key: "key"})
		# stretchr.people(1).cars.path # => people/1/cars
		def method_missing(method, *args)
			r = Stretchr::Request.new({base_url: "https://#{project}.stretchr.com/api/#{api_version}/"})
			r.send(method, *args)
		end
	end
end