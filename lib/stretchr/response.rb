require "json"
module Stretchr
	class Response
		attr_reader :raw, :parsed, :data
		def initialize(response, options = {})
			@api_version = options[:api_version] || Stretchr.config["api_version"]
			@raw = response
			@parsed = JSON.parse(response)
			@data = @parsed[Stretchr.config[@api_version]["data"]]
		end

		def success?
			@parsed[Stretchr.config[@api_version]["status"]] >= 200 && @parsed[Stretchr.config[@api_version]["status"]] <= 299
		end
	end
end