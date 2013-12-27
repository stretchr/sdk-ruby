# Config File 
# This file contains all the configuration for the stretchr api
# and this gem.  They are namespaced by api version where appropriate
require "yaml"
module Stretchr
	def self.config
		@config ||= YAML::load_file(File.join(File.dirname(__FILE__), "stretchr/defaults.yaml"))
	end
end

# The main stretchr client
require "stretchr/client"

# The main stretchr request, this is where the url is built
require "stretchr/request"

# Bags are responsible for hanging on to params while building urls
require "stretchr/bag"

# Transporters
# A transporter is anything that actually makes requests
# It is a class with only one public function: make_request(request)
# you pass in a request object, it performs the request and then
# returns a response object
require "stretchr/transporters/test_transporter" # a transporter for testing, does not make real requests
require "stretchr/transporters/json_transporter" # a transporter that uses json to talk to stretchr

# Response object
# The response object takes in a JSON response from stretchr
# and parses it into more easily used data
require "stretchr/response"