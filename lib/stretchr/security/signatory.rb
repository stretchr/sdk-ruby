require 'uri' unless defined? URI
require 'cgi' unless defined? CGI
require 'digest/sha1'

class Stretchr::Signatory
	class << self
		def generate_signed_url(method, uri, public_key, private_key, body = nil)

			#we need a URI, let's make sure it's what we have
			uri = URI.parse(URI.escape(uri)) unless uri.is_a?(URI)

			#preparation
			query = CGI.parse(uri.query || "")
			query["~key"] = public_key

			#store this for later, we'll need it
			public_query = URI.encode_www_form(query) 

			#now add the private stuff
			query["~private"] = private_key
			query["~bodyhash"] = Digest::SHA1.hexdigest(body) unless body == nil

			#sort it
			query = sort_query(query)
			uri.query = URI.encode_www_form(query)


			#append the method
			signature = generate_signature(method, uri.to_s)


			#now we prepare it for public use
			public_query = public_query + "&" unless public_query == nil
			uri.query = public_query + CGI.escape("~sign=#{signature}")

			return uri
		end

		private

		def generate_signature(http_method, private_url)
			Digest::SHA1.hexdigest("#{http_method.to_s.upcase}&#{CGI.unescape(private_url.to_s)}")
		end

		def sort_query(query)
			query.each do |key, value|
				value.sort! if value.is_a?(Array)
			end.sort
		end
	end
end