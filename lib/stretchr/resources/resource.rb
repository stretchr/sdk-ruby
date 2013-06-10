module Stretchr
	class Resource

		# Class Methods to find objects

		def self.find(params = {})
			stretchr = stretchr_client
			#FIXME : Why does this need to be duplicated?
			stretchr.path = prep_path(stretchr.path.dup, params)
			response = stretchr.get
			self.new(response.data)
		end

		def self.all(params = {})
			stretchr = stretchr_client
			stretchr.path = prep_path(stretchr.path.dup, params)
			response = stretchr.get
			response.data["~i"].map {|r| self.new(r)}
		end

		def self.stretchr_client
			@client ||= Stretchr::Client.new(@config)
		end

		def self.stretchr_config(params = {})
			@config ||= {}
			@config.merge!(params)
		end

		# Instance Methods

		def initialize(params = {})
			@attributes = {}
			params.each {|key, value| self.send("#{key}=", value) }
		end

		def save(params = {})
			stretchr = self.class.stretchr_client
			stretchr.path = self.class.prep_path(stretchr.path.dup, params)
			response = stretchr.post
			parse_response(response)
		end

		def parse_response(response)
			#FIXME : Should handle change objects and deltas here and update the object accordingly
			if response.changed
				response.changed.each {|key, value| self.send("#{key}=", value)}
			end 
		end
	  
		def method_missing(method, *args)
			attribute = method.to_s
			if attribute =~ /=$/ #if the method name ends in an =
				@attributes[attribute.chop.gsub("~", "stretchr_")] = args[0]
			else
				@attributes[attribute]
			end
		end

		private

		def self.prep_path(path, params = {})
			params.each {|key, value| path.gsub!(":#{key.to_s}", value) }
			#remove any unchanged params from the path
			path.gsub!(/(:[a-zA-Z0-9_-]*)/, "")
			path
		end

	end
end