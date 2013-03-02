require "uri" if !defined? URI
require "net/http" if !defined? Net

class Stretchr::DefaultTransporter

	def make_request(request)
		response = nil
		Net::HTTP.start(request.signed_uri.host, request.signed_uri.port) do |http|

		  http_request = generate_request(request)
		  response = http.request http_request # Net::HTTPResponse object

		end

		return Stretchr::Response.new({:response => response, :json => response.body})
	end

	def generate_request(request)
		case request.http_method
		when :get
			req = Net::HTTP::Get.new request.signed_uri.request_uri
		when :post
			req = Net::HTTP::Post.new request.signed_uri.request_uri
			req.body = request.body
			req
		when :put
			req = Net::HTTP::Put.new request.signed_uri.request_uri
			req.body = request.body
			req
		when :delete
			req = Net::HTTP::Delete.new request.signed_uri.request_uri
		end
	end

end