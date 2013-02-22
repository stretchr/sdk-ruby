require "uri"
require "cgi"


class Stretchr

  require 'stretchr/security'
  require 'stretchr/transporters'
  require 'stretchr/resources'
  require 'stretchr/stretchr_request'
  require 'stretchr/stretchr_response'

  # some errors

  class StretchrError < StandardError; end
  class MissingAttributeError < StretchrError; end

	def initialize(options = {})
		
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

  	attr_accessor :project, :private_key, :public_key, :path, :http_method, :body, :version, :transporter, :signatory

    #-------------------HTTP Actions-----------------

    # generate_request makes a Stretchr::Request based on the current settings
    # in this Stretchr object.
    def generate_request
      Stretchr::Request.new(
        :http_method => http_method,
        :signed_uri => signed_uri
      )
    end

    def make_request!
      # create and make the request
      self.transporter.make_request(generate_request)
    end

    # get performs a GET request and returns the Stretchr::Response.
    def get

      self.http_method = :get

      make_request!

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
      Stretchr::Signatory.generate_signed_url(http_method, uri, public_key, private_key, body)
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

  	#-----------------Basic Routing-----------------

  	def method_missing(method, *args)
  		add_collection(method, *args)
  	end

  	private

  	def merge_query

      # 1.8.7 compatible, removed in favor of 1.9.  saved for reference
      # unless @query == nil || @query == {}
      #   @query.collect do |key, value|
      #     #"#{CGI.escape(key.to_s)}=#{CGI.escape(value.to_s)}" do we want to CGI escape?
      #     "#{key}=#{value}"
      #   end.sort * "&"
      # end

      unless @query == nil || @query == {}
        URI.encode_www_form(@query)
      end
  	end

    def merge_path
      "/api/#{version}" + @path
    end

  	def add_collection(collection, id = nil)
  		@path += "/#{collection}"
  		if id
  			id.gsub!(/[^0-9A-Za-z.\-]/, '_') if id.is_a?(String) #remove non-ascii
  			@path += "/#{id}"
  		end
  		self
  	end
end