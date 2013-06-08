#FIXME : Right now we just define some errors that users can implement if they wish.  Should we implement them for them?
module Stretchr
	#basic stretchr error namespace
	class StretchrError < StandardError; end

	#Configuration
	class MissingAttributeError < StretchrError; end #thrown when initializing client without params
	class UnknownConfiguration < StretchrError; end #thrown when we try to set an unknown configuration option

	#stretchr object not found
	class Notfound < StretchrError; end
	#don't know what happened here!
	class Unknown < StretchrError; end
end