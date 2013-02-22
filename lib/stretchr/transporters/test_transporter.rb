class Stretchr::TestTransporter

  attr_accessor :requests, :responses

  def initialize
    self.requests = []
    self.responses = []
  end

	def make_request(request)
		# store the request and return the next response in the local queue
		# not NOT actually make any http requests

    self.requests << request

    # return the response
    self.responses.shift

	end
end