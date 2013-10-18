require "uri"

module Stretchr
	# The request class is where most of the url building magic takes place
	# It collects all methods passed to it and uses them to build a url for you
	class Request
		attr_accessor :client
		def initialize(options = {})
			# Pass in the client so we get all the options required
			self.client = options[:client]

			# URL BUILDING
			# This is where we'll initialize everything needed to build up the urls
			@path_elements = []
			@params = Stretchr::Bag.new # a bag to hold the params for th url building
			@filters = Stretchr::Bag.new({prefix: ":"}) # a bag to hold the filters
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
			URI::HTTPS.build(host: merge_host, path: merge_path, query: merge_query)
		end

		# Set params for the url
		# ==== Examples
		# r = Stretchr::Request.new
		# r.param("key", "value")
		def param(key, value)
			@params.set(key, value)
			return self
		end

		# Set filters for the url
		# ==== Examples
		# r = Stretchr::Request.new
		# r.where("key", "value")
		def where(key, value)
			@filters.set(key, value)
			return self
		end

		# Performs a GET for the current request
		# Returns a Stretchr::Response object
		#
		# ==== Examples
		# r = Stretchr::Request.new
		# r.people.get #=> Stretchr::Response object
		def get
			self.make_request!({uri: this.to_uri, method: :get})
		end

		# Performs a POST to create a new resource
		# Returns a Stretchr::Response object
		#
		# ==== Examples
		# r = Stretchr::Request.new
		# r.people.create({name: "ryan"}) #=> Stretchr::Response object
		def create(body)
			self.make_request!({uri: this.to_uri, method: :post, body: body})
		end

		# Performs a PUT to replace an object
		# Returns a Stretchr::Response object
		#
		# ==== Examples
		# r = Stretchr::Request.new
		# r.people.replace({name: "ryan"}) #=> Stretchr::Response object
		def replace(body)
			self.make_request!({uri: this.to_uri, method: :put, body: body})
		end

		# Performs a PATCH to update an object
		# will not delete non-included fields
		# just update included ones
		# Returns a Stretchr::Response object
		#
		# ==== Examples
		# r = Stretchr::Request.new
		# r.people.update({name: "ryan"}) #=> Stretchr::Response object
		def update(body)
			self.make_request!({uri: this.to_uri, method: :patch, body: body})
		end

		# Performs a DELETE to remove an object
		# deletes an object or entire collection
		# SERIOUSLY - THIS DELETES THINGS
		#
		# ==== Examples
		# r = Stretchr::Request.new
		# r.people.remove #=> Stretchr::Response object
		def remove
			self.make_request!({uri: this.to_uri, method: :delete})
		end

		# Actually sends the request to the transporter
		def make_request!(options = {})
			self.client.transporter.make_request(options)
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
			"/api/#{client.api_version}/#{@path_elements.join('/')}"
		end

		def merge_query
			p = []
			p << @params.query_string unless @params.query_string == ""
			p << @filters.query_string unless @filters.query_string == ""
			return p.size > 0 ? p.join("&") : nil
		end

		def merge_host
			"#{client.project}.#{client.hostname}"
		end
	end
end