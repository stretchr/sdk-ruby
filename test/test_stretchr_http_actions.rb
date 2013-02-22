require 'test/unit'
require 'test_helper.rb'
require 'stretchr'

class StretchrHttpActionsTest < Test::Unit::TestCase

  def test_get

    stretchr = test_stretchr_object

    test_response = Stretchr::Response.new(:json => '{"~s":200,"~d":{"name":"Ryan"}}')
    stretchr.transporter.responses << test_response

    response_from_get = stretchr.people(123).get

    assert_equal(response_from_get, test_response, "response from get should be the response form the transporter")
    
    if assert_equal(1, stretchr.transporter.requests.length)
      
      request = stretchr.transporter.requests[0]
      
      assert_equal(:get, request.http_method, "http_method")
      assert_nil(request.body, "body")
      assert_equal("http://project.company.stretchr.com/api/v1/people/123?%7Ekey=test&%7Esign%3Da6bfa773f9169dbeae077ba6a8ac3da07fc19db3", request.signed_uri.to_s)

    end

  end

  def test_post

    stretchr = test_stretchr_object

    test_response = Stretchr::Response.new(:json => '{"~s":200,"~d":{"name":"Ryan"}}')
    stretchr.transporter.responses << test_response

    response_from_get = stretchr.people(123).body({:name=>"Mat"}).post

    assert_equal(response_from_get, test_response, "response from get should be the response form the transporter")
    
    if assert_equal(1, stretchr.transporter.requests.length)
      
      request = stretchr.transporter.requests[0]
      
      assert_equal(:post, request.http_method, "http_method")
      assert_equal(request.body[:name], "Mat")
      assert_equal("http://project.company.stretchr.com/api/v1/people/123?%7Ekey=test&%7Esign%3Da6bfa773f9169dbeae077ba6a8ac3da07fc19db3", request.signed_uri.to_s)

    end

  end

  def test_put

    stretchr = test_stretchr_object

    test_response = Stretchr::Response.new(:json => '{"~s":200,"~d":{"name":"Ryan"}}')
    stretchr.transporter.responses << test_response

    response_from_get = stretchr.people(123).body({:name=>"Mat"}).put

    assert_equal(response_from_get, test_response, "response from get should be the response form the transporter")
    
    if assert_equal(1, stretchr.transporter.requests.length)
      
      request = stretchr.transporter.requests[0]
      
      assert_equal(:put, request.http_method, "http_method")
      assert_equal(request.body[:name], "Mat")
      assert_equal("http://project.company.stretchr.com/api/v1/people/123?%7Ekey=test&%7Esign%3Da6bfa773f9169dbeae077ba6a8ac3da07fc19db3", request.signed_uri.to_s)

    end

  end

  def test_delete

    stretchr = test_stretchr_object

    test_response = Stretchr::Response.new(:json => '{"~s":200,"~d":{"name":"Ryan"}}')
    stretchr.transporter.responses << test_response

    response_from_get = stretchr.people(123).body({:name=>"Mat"}).delete

    assert_equal(response_from_get, test_response, "response from get should be the response form the transporter")
    
    if assert_equal(1, stretchr.transporter.requests.length)
      
      request = stretchr.transporter.requests[0]
      
      assert_equal(:put, request.http_method, "http_method")
      assert_nil(request.body, "body")
      assert_equal("http://project.company.stretchr.com/api/v1/people/123?%7Ekey=test&%7Esign%3Da6bfa773f9169dbeae077ba6a8ac3da07fc19db3", request.signed_uri.to_s)

    end

  end

end
