require "cgi" unless defined? CGI
require_relative "../lib/stretchr"
require "minitest/autorun"

def load_api_response(filename)
	File.open(File.join(Dir.pwd, "test", "stubs", filename)) {|f| f.read }
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