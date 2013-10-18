require "json"
module Stretchr
	class Response
		attr_reader :raw, :parsed, :data, :api_version, :errors, :changes, :status
		def initialize(response, options = {})
			@api_version = options[:api_version] || Stretchr.config["api_version"]
			@raw = response
			@parsed = JSON.parse(response)
			begin
				@data = @parsed[Stretchr.config[@api_version]["data"]]
				@errors = @parsed[Stretchr.config[@api_version]["errors"]]
				@changes = @parsed[Stretchr.config[@api_version]["changes"]]
				@status = @parsed[Stretchr.config[@api_version]["status"]]
			rescue
			end
		end

		def success?
			@status >= 200 && @status <= 299
		end
	end
end