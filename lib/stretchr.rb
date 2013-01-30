
class Stretchr

  require 'stretchr/security'
  require 'stretchr/transporters'

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
      @signatory = Stretchr::Signatory.new
      @transporter = Stretchr::DefaultTransporter.new
      @version ||= "v1"
      @path ||= ""
      @parameters = {}

  	end

  	attr_accessor :project, :private_key, :public_key, :path, :version, :transporter, :signatory

  	#----------------Friendly Functions--------------
  	def url
  		url = "http://#{project}.stretchr.com/api/#{version}#{path}#{merge_params}"
  	end

  	def to_url
  		url
  	end

  	#---------------Parameter Building---------------

  	def where(parameters)
  		
  	end

  	def order(parameters)
  		@parameters[:order] = parameters.to_s
  		self
  	end

  	def skip(parameters)
  		@parameters[:skip] = parameters.to_i
  		self
  	end

  	def limit(parameters)
  		@parameters[:limit] = parameters.to_i
  		self
  	end

  	def page(parameters)
  		skip((@parameters[:limit] * parameters.to_i) - @parameters[:limit])
  		self
  	end

  	def parameters(parameters)
  		@parameters.merge!(parameters)
  		self
  	end

  	#-----------------Basic Routing-----------------

  	def method_missing(method, *args)
  		add_collection(method, *args)
  	end

  	private

  	def merge_params
  		unless @parameters.empty?
	  		params = @parameters.collect { |k,v| "~#{k}=#{v}"}
	  		params = params.join("&")
	  	  params.insert(0, '?') unless @query.start_with?("?")
	  	end
  		params
  	end

  	def add_collection(collection, id = nil)
  		@path += "/#{collection}"
  		if id
  			id.gsub!(/[^0-9A-Za-z.\-]/, '_') if id.is_a?(String)#remove non-ascii?  how do we feel about this?
  			@path += "/#{id}"
  		end
  		self
  	end
end