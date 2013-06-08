require 'test/unit'
require 'test_helper.rb'

class StretchrRequestTest < Test::Unit::TestCase

  def test_new

    uri = URI.parse("http://test.stretchr.com/api/v1")
    r = Stretchr::Request.new(
      :http_method => :get,
      :signed_uri => uri,
      :body => "This is the body",
      :headers => {
        "X-Custom-Header" => "Hello"
      }
    )

    assert_equal(r.http_method, :get)
    assert_equal(r.signed_uri, uri)
    assert_equal(r.body, "This is the body")
    assert_equal(r.headers["X-Custom-Header"], "Hello")

  end

end
