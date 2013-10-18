require "json"
module Stretchr
	# Response parser for stretchr
	# ==== Parameters
	# +response+ - The raw response from stretchr
	# +options[:api_version]+ - The version of the api we're talking to, tells us how to parse
	class Response
		attr_reader :raw, :parsed, :data, :api_version, :errors, :changes, :status
		def initialize(response, options = {})
			@api_version = options[:api_version] || Stretchr.config["api_version"] #api version is used to determine how to parse response
			@raw = response
			@parsed = JSON.parse(response)
			begin
				@data = @parsed[Stretchr.config[@api_version]["data"]] #stretchr data object
				@errors = @parsed[Stretchr.config[@api_version]["errors"]] #errors
				@changes = @parsed[Stretchr.config[@api_version]["changes"]] #changes (POST/PUT/PATCH/DELETE)
				@status = @parsed[Stretchr.config[@api_version]["status"]] #request status
			rescue
			end
		end

		# Returns whether or not the request was successful
		def success?
			@status >= 200 && @status <= 299
		end
	end
end