require "cgi" unless defined? CGI
require_relative "../lib/stretchr"

def test_stretchr_object
  Stretchr::Client.new({transporter: Stretchr::TestTransporter.new, private_key: 'ABC123-private', public_key: "test", project: "project.company"})
end

module Stretchr
	class GenerateResponse
		class << self
			def get_single_response(params = {})
				response = {
					"~s" => params[:status] || 200,
					"~d" => params[:data],
				}
				response["~e"] = params[:errors] if params[:errors]
				response["~x"] = params[:context] if params[:context]
				response["~ch"] = params[:change_info] if params[:change_info]
				response.to_json
			end

			def get_collection_response(params = {})
				response = {
					"~s" => params[:status] || 200,
					"~d" => {
							"~t" => params[:total] || 10,
							"~c" => params[:in_response] || 0
						},
				}
				if params[:objects]
					response["~d"]["~i"] = params[:objects]
					response["~d"]["~c"] = params[:objects].length
				end
				response["~e"] = params[:errors] if params[:errors]
				response["~x"] = params[:context] if params[:context]
				response["~ch"] = params[:change_info] if params[:change_info]
				response.to_json
			end

			def post_response(params = {})
				response = {
					"~s" => params[:status] || 200,
					"~ch" => {"~c" => 1, "~u" => 1, "~d" => 0 }
				}
				response["~ch"]["~deltas"] = params[:deltas] if params[:deltas]
				response.to_json
			end

			def put_response(params = {})
				{

				}
			end

		end
	end
end

module URI

	def get_param(param)
		CGI.parse(CGI.unescape(self.query))[param]
	end

	def validate_param_value(param, value)
		CGI.parse(CGI.unescape(self.query))[param].include?(value)
	end

	def validate_param_presence(param)
    return false if self.query == nil
		CGI.parse(CGI.unescape(self.query))[param] == [] ? false : true
	end

end