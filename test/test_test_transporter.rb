require 'test/unit'
require 'test_helper.rb'
require 'stretchr'

class TestTransporterTest < Test::Unit::TestCase

  def test_test_transporter

    t = Stretchr::TestTransporter.new

    testRequest = Stretchr::Request.new
    testResponse = Stretchr::Response.new

    # queue up the repsonse
    t.responses << testResponse

    # make the request
    returnedResponse = t.make_request(testRequest)

    if assert_not_nil(t.requests, ".requests should be an array") 
      assert_equal(1, t.requests.length, "Should be one recorded request")
      assert_equal(testRequest, t.requests[0], "Request should be added to .requests")
    end

    assert_equal(returnedResponse, testResponse, "Response in queue should be returned")
    assert_equal(0, t.responses.length, ".responses should lose items as they're returned") 

  end

  def test_test_transporter_response

    t = Stretchr::TestTransporter.new

    testRequest = Stretchr::Request.new

    # make the request
    returnedResponse = t.make_request(testRequest)

    assert_nil(returnedResponse)

  end

end