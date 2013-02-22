require "cgi" unless defined? CGI

module URI
	def validate_param_value(param, value)
		CGI.parse(self.query)[param].include?(value)
	end

	def validate_param_presence(param)
		CGI.parse(CGI.unescape(self.query))[param] == [] ? false : true
	end
end