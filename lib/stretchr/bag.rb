module Stretchr
	class Bag
		def initialize
			@params = {}
		end

		def set(param, value)
			@params[param] = value
		end

		def get(param)
			@params[param]
		end
	end
end