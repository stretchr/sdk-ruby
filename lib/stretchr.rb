require "uri"
require "cgi"
require "json"

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