#FIXME : Right now we just define some errors that users can implement if they wish.  Should we implement them for them?
module Stretchr
	#basic stretchr error namespace
	class StretchrError < StandardError; end
	#missing a required attribute for the client
	class MissingAttributeError < StretchrError; end
	#stretchr object not found
	class Notfound < StretchrError; end
	#don't know what happened here!
	class Unknown < StretchrError; end
end