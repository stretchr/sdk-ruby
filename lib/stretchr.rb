class Stretchr
	def initialize(attributes = {})
		#current supported attributes are project, private_key, public _key and version
    	attributes.each do |name, value|
      		send("#{name}=", value)
    	end

    	#-----DEFAULTS------

    	@version ||= "v1"
    	@path = ""
    	@query = ""
    	@attributes = {}
  	end

  	attr_accessor :project, :private_key, :public_key, :path, :version

  	#----------------Friendly Functions--------------
  	def url
  		url = "http://#{project}.stretchr.com/api/#{version}#{path}#{merge_params}"
  	end

  	def to_url
  		url
  	end

  	#---------------Parameter Building---------------

  	def where(attributes)
  		
  	end

  	def order(attributes)
  		@attributes[:order] = attributes.to_s
  		self
  	end

  	def skip(attributes)
  		@attributes[:skip] = attributes.to_i
  		self
  	end

  	def limit(attributes)
  		@attributes[:limit] = attributes.to_i
  		self
  	end

  	def page(attributes)
  		skip((@attributes[:limit] * attributes.to_i) - @attributes[:limit])
  		self
  	end

  	def attributes(attributes)
  		@attributes.merge!(attributes)
  		self
  	end

  	#-----------------Basic Routing-----------------

  	def method_missing(method, *args)
  		add_collection(method, *args)
  	end

  	private

  	def merge_params
  		unless @attributes.empty?
	  		params = @attributes.collect { |k,v| "~#{k}=#{v}"}
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