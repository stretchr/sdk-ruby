module Stretchr
	class JSONTransporter
		def make_request(request, options = {})
			Net::HTTP.start(request[:uri].host, request[:uri].port) do |http|
				http_request = generate_request(request)
				response = http.request http_request # Net::HTTPResponse object
			end

			return Stretchr::Response.new(response.body, {:api_version => client.api_version})
		end

		def generate_request(request)

			request_uri = request.uri.request_uri

			case request[:method]
				when :get
					req = Net::HTTP::Get.new request_uri
				when :post
					req = Net::HTTP::Post.new request_uri, {'Content-Type' => "application/json"}
					req.body = request.body
					req
				when :put
					req = Net::HTTP::Put.new request_uri, {'Content-Type' => "application/json"}
					req.body = request.body
					req
				when :delete
					req = Net::HTTP::Delete.new request_uri
			end
		end
	end
end