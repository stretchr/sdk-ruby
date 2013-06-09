module Stretchr
	class Resource

		def initialize
			@attributes = {}
		end

		def self.stretchr_client
			@client ||= Stretchr::Client.new({path: @config ? @config[:path] : nil})
		end

		def self.stretchr_config(params = {})
			@config ||= {}
			@config.merge(params)
		end
	  
		def method_missing(method, *args)
			attribute = method.to_s
			if attribute =~ /=$/ #if the method name ends in an =
				@attributes[attribute.chop] = args[0]
			else
				@attributes[attribute]
			end
		end

	end
end