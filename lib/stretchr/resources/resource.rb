module Stretchr
	class Resource

		# Class Methods to find objects

		def self.find(params = {})
			stretchr = stretchr_client
			#FIXME : Why does this need to be duplicated?
			stretchr.path = prep_path(stretchr.path.dup, params)
			response = stretchr.get
			return false if !response.success?
			self.new(response.data)
		end

		def self.all(params = {})
			stretchr = stretchr_client
			stretchr.path = prep_path(stretchr.path.dup, params)
			response = stretchr.get
			return [] if response.data["~c"] == 0 || !response.data["~i"]
			response.data["~i"].map {|r| self.new(r) }
		end

		def self.where(params = {})
			stretchr = stretchr_client
			#snag the vars that are needed for the path
			path_vars = stretchr.path.scan(/:([a-zA-Z0-9_-]*)/i).flatten
			#now convert the path as best we can
			stretchr.path = prep_path(stretchr.path.dup, params)
			#now remove the path params from the request
			params.delete_if {|key, value| path_vars.include?(key.to_s)}

			response = stretchr.where(params).get
			#return false if nothing returned or search wasn't successful
			return false if !response.success? || response.data["~c"] == 0 || !response.data["~i"]
			response.data["~i"].map {|i| self.new(i) }
		end

		def self.stretchr_client
			Stretchr::Client.new(@config)
		end

		def self.create(objects = [], params = {})
			#convert it to an array for easy adding
			objects = [objects] if !objects.is_a?(Array)
			objects.map! {|o| setup_attributes_for_stretchr(o) }
			stretchr = stretchr_client
			stretchr.path = prep_path(stretchr.path.dup, params)
			stretchr.body(objects)
			response = stretchr.post
			count = 0
			stretchr_objects = objects.map do |o|
				account = self.new(o)
				account.parse_changes(response.changed[count])
				count += 1
				account
			end
			return stretchr_objects.first if stretchr_objects.length == 1
			return stretchr_objects
		end

		def self.stretchr_config(params = {})
			@config ||= {}
			@config.merge!(params)
		end

		# Instance Methods

		def initialize(params = {})
			@attributes = {}
			params.each {|key, value| self.send("#{key}=", value) }
		end

		def save(params = {})
			stretchr = self.class.stretchr_client
			stretchr.path = self.class.prep_path(stretchr.path.dup, params)
			stretchr.body(setup_attributes_for_stretchr)
			if self.stretchr_id
				response = stretchr.put
			else
				response = stretchr.post
			end
			parse_changes(response.changed)
		end

		def parse_changes(response)
			#FIXME : Should handle change objects and deltas here and update the object accordingly
			return unless response
			response.each {|key, value| self.send("#{key}=", value)}
			self
		end

		def to_hash
			@attributes
		end

		def to_json
			to_hash.to_json
		end
	  
		def method_missing(method, *args)
			attribute = method.to_s
			if attribute =~ /=$/ #if the method name ends in an =
				@attributes[attribute.chop.gsub("~", "stretchr_")] = args[0]
			else
				@attributes[attribute]
			end
		end

		private

		def self.prep_path(path, params = {})
			params.each {|key, value| path.gsub!(":#{key.to_s}", value.to_s) unless value == nil}
			#remove any unchanged params from the path
			path.gsub!(/(:[a-zA-Z0-9_-]*)/, "")
			path
		end

		def setup_attributes_for_stretchr
			self.class.setup_attributes_for_stretchr(@attributes)
		end

		def self.setup_attributes_for_stretchr(attributes)
			stretchr_attributes = {}
			attributes.each_pair {|key, value| stretchr_attributes[key.to_s.gsub(/^stretchr_/, "~")] = value}
			stretchr_attributes
		end

	end
end