module Stretchr
	class TestTransporter
		attr_accessor :requests, :responses
		def initialize
			self.requests = []
			self.responses = []
		end

		def make_request(request)
			requests << request
			responses.shift
		end
	end
end