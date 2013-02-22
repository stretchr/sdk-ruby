class Stretchr::Request

  attr_accessor :http_method, :body, :signed_uri, :headers

  def initialize(options = {})

    @http_method = options[:http_method]
    @body = options[:body]
    @signed_uri = options[:signed_uri]
    @headers = options[:headers]

  end

end