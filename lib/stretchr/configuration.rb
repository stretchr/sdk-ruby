module Stretchr

	class Configuration

		def self.add_option(name, default_value = nil)
			attr_accessor name
			@name = default_value		
		end

		add_option :private_key
		add_option :public_key
		add_option :project
		add_option :noisy_errors

		def method_missing(name, *params)
			raise Stretchr::UnknownConfiguration
		end
	end

end