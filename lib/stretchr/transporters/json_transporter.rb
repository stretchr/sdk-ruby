require "uri" if !defined? URI
require "net/http" if !defined? Net
require "json" if !defined? JSON

module Stretchr
	class JSONTransporter
		# Perform the request against stretchr
		# ==== Parameters
		# +request+ - The request object
		# Expects: {uri: URIOBJECT, body: "body", method: "PUT/PATCH/POST/DELETE/GET", client: stretchr client}
		def make_request(request)
			response = nil

			#convert to a json string unless the user already did it...
			request[:body] = request[:body].to_json unless request[:body].is_a? String

			Net::HTTP.start(request[:uri].host, request[:uri].port) do |http|
				http_request = generate_request(request)
				response = http.request http_request # Net::HTTPResponse object
			end
			if request[:client]
				return Stretchr::Response.new(response.body, {:api_version => request[:client].api_version})
			else
				return Stretchr::Response.new(response.body)
			end
		end

		# Generates the actual request, including the method
		def generate_request(request)

			request_uri = request[:uri].request_uri

			case request[:method]
			when :get
				req = Net::HTTP::Get.new request_uri
			when :post
				req = Net::HTTP::Post.new request_uri, {'Content-Type' => "application/json"}
				req.body = request[:body]
				req
			when :put
				req = Net::HTTP::Put.new request_uri, {'Content-Type' => "application/json"}
				req.body = request[:body]
				req
			when :patch
				req = Net::HTTP::Patch.new request_uri, {'Content-Type' => "application/json"}
				req.body = request[:body]
				req
			when :delete
				req = Net::HTTP::Delete.new request_uri
			end
		end
	end
end