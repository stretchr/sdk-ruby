require "uri"
require "cgi"
require "json"


module Stretchr
	#exceptions that can be used by stretchr
	require_relative 'stretchr/exceptions'

	#configuration
	require_relative 'stretchr/configuration'

	@configuration = Stretchr::Configuration.new

	def self.configuration
		@configuration
	end

	def self.config
		yield(@configuration)	
	end

	#the actual client library
	require_relative 'stretchr/client'
	require_relative 'stretchr/security'
	require_relative 'stretchr/transporters'
	require_relative 'stretchr/resources'
	require_relative 'stretchr/stretchr_request'
	require_relative 'stretchr/stretchr_response'

	
end