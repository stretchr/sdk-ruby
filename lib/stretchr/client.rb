module Stretchr

	class Client
		def initialize(options = {})
			options ||= {}
		
			options[:project] ||= Stretchr.configuration.project
			options[:private_key] ||= Stretchr.configuration.private_key
			options[:public_key] ||= Stretchr.configuration.public_key
			options[:noisy_errors] ||= (Stretchr.configuration.noisy_errors || false)
			# check for required arguments
			[:project, :public_key, :private_key].each do | required_option |
				raise MissingAttributeError, "#{required_option} is required." unless options[required_option]
			end

			options.each do |name, value|
					send("#{name}=", value)
			end

			# create defaults if the user didn't specify anything
			@signatory ||= Stretchr::Signatory
			@transporter ||= Stretchr::DefaultTransporter.new
			@version ||= "v1"
			@path ||= ""
			@query = {}

		end

		attr_accessor :project, :private_key, :public_key, :path, :http_method, :http_body, :version, :transporter, :signatory, :noisy_errors

		#-------------------HTTP Actions-----------------

		# generate_request makes a Stretchr::Request based on the current settings
		# in this Stretchr object.
		def generate_request
			Stretchr::Request.new(
				:http_method => http_method,
				:signed_uri => signed_uri,
				:body => http_body
			)
		end

		def make_request!
			# create and make the request
			response = self.transporter.make_request(generate_request)
			raise_errors_in_response(response) if noisy_errors
			response
		end

	    def raise_errors_in_response(response)
	        if [404, 500, 401, 403, 406, 400].include?(response.status)
	          raise_error(response.status)
	        end 
	    end

	    def raise_error(status)
	      case status
	      when 404 
	        raise NotFound
	      when 500 
	        raise InternalServerError
	      when 401 
	        raise Unauthorized
	      when 403 
	        raise Forbidden
	      when 400 
	        raise BadRequest
	      else
	        raise Unknown
	      end    
	    end

		# get performs a GET request and returns the Stretchr::Response.
		def get

			self.http_method = :get
			make_request!

		end

		# post performs a POST and returns a Stretch::Response
		def post
			self.http_method = :post
			make_request!
		end

		def put
			self.http_method = :put
			make_request!
		end

		def delete
			self.http_method = :delete
			make_request!
		end

	    #---------------- Friendly Actions --------------

	    def create(object)
	      self.body(object).post
	    end

	    def replace(object)
	      self.body(object).post
	    end

	    def update(object)
	      self.body(object).put
	    end

	    def read
	      self.get
	    end

		#----------------Friendly Functions--------------
		def url
			uri.to_s
		end

		def to_url
			url
		end

		def uri
			URI::HTTP.build(host: "#{project}.stretchr.com", query: merge_query, path: merge_path)
		end

		def signed_uri
			Stretchr::Signatory.generate_signed_url(http_method, uri, public_key, private_key, http_body)
		end

		#---------------Parameter Building---------------

		def order(parameters)
			@query["~order"] = parameters.to_s
			self
		end

		def skip(parameters)
			@query["~skip"] = parameters.to_i
			self
		end

		def limit(parameters)
			@query["~limit"] = parameters.to_i
			self
		end

		def page(parameters)
			skip((@query["~limit"] * parameters.to_i) - @query["~limit"])
			self
		end

		def parameters(parameters)
			@query.merge!(parameters)
			self
		end

		def body(body_params)
			self.http_body = body_params.to_json

			self
		end

		def where(params)
			params.each do |key, value|
				@query["\:#{key.to_s}"] = value
			end
			self
		end

		#-----------------Basic Routing-----------------

		def method_missing(method, *args)
			add_collection(method, *args)
		end

		def add_collection(collection, id = nil)
			@path += "/#{collection}"
			if id
				id.gsub!(/[^0-9A-Za-z.\-]/, '_') if id.is_a?(String) #remove non-ascii
				@path += "/#{id}"
			end
			self
		end

		private

		def merge_query
			unless @query == nil || @query == {}
				URI.encode_www_form(@query)
			end
		end

		def merge_path
			"/api/#{version}" + @path
		end

	end

end