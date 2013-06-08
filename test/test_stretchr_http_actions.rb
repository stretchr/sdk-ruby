require 'test/unit'
require 'test_helper.rb'

class StretchrHttpActionsTest < Test::Unit::TestCase

  def test_create

    stretchr = test_stretchr_object

    test_response = Stretchr::Response.new(:json => '{"~s":200,"~d":{"name":"Ryan"}}')
    stretchr.transporter.responses << test_response

    response_from_post = stretchr.people(123).create({:name=>"Ryan"})

    assert_equal(response_from_post, test_response, "response from get should be the response form the transporter")
    
    if assert_equal(1, stretchr.transporter.requests.length)
      
      request = stretchr.transporter.requests[0]
      
      assert_equal(:post, request.http_method, "http_method")
      assert_equal(request.body, {:name=>"Ryan"}.to_json)
      assert_equal("http://project.company.stretchr.com/api/v1/people/123?%7Ekey=test&%7Esign=a2c48a40179fdd9db12f157d289e9ec79b00fe04", request.signed_uri.to_s)

    end

  end

  def test_update

    stretchr = test_stretchr_object

    test_response = Stretchr::Response.new(:json => '{"~s":200,"~d":{"name":"Ryan"}}')
    stretchr.transporter.responses << test_response

    response_from_put = stretchr.people(123).update({:name=>"Mat"})

    assert_equal(response_from_put, test_response, "response from get should be the response form the transporter")
    
    if assert_equal(1, stretchr.transporter.requests.length)
      
      request = stretchr.transporter.requests[0]
      
      assert_equal(:put, request.http_method, "http_method")
      assert_equal(request.body, {:name=>"Mat"}.to_json)
      assert_equal("http://project.company.stretchr.com/api/v1/people/123?%7Ekey=test&%7Esign=837147f09451a998c041c328821c6b72f88f3336", request.signed_uri.to_s)

    end

  end

  def test_replace

    stretchr = test_stretchr_object

    test_response = Stretchr::Response.new(:json => '{"~s":200,"~d":{"name":"Ryan"}}')
    stretchr.transporter.responses << test_response

    response_from_post = stretchr.people(123).replace({:name=>"Ryan"})

    assert_equal(response_from_post, test_response, "response from get should be the response form the transporter")
    
    if assert_equal(1, stretchr.transporter.requests.length)
      
      request = stretchr.transporter.requests[0]
      
      assert_equal(:post, request.http_method, "http_method")
      assert_equal(request.body, {:name=>"Ryan"}.to_json)
      assert_equal("http://project.company.stretchr.com/api/v1/people/123?%7Ekey=test&%7Esign=a2c48a40179fdd9db12f157d289e9ec79b00fe04", request.signed_uri.to_s)

    end

  end

  def test_read

    stretchr = test_stretchr_object

    test_response = Stretchr::Response.new(:json => '{"~s":200,"~d":{"name":"Ryan"}}')
    stretchr.transporter.responses << test_response

    response_from_get = stretchr.people(123).read

    assert_equal(test_response, response_from_get, "response from get should be the response form the transporter")
    
    if assert_equal(1, stretchr.transporter.requests.length)
      
      request = stretchr.transporter.requests[0]
      
      assert_equal(:get, request.http_method, "http_method")
      assert_nil(request.body, "body")
      assert_equal("http://project.company.stretchr.com/api/v1/people/123?%7Ekey=test&%7Esign=a6bfa773f9169dbeae077ba6a8ac3da07fc19db3", request.signed_uri.to_s)

    end

  end

  def test_get

    stretchr = test_stretchr_object

    test_response = Stretchr::Response.new(:json => '{"~s":200,"~d":{"name":"Ryan"}}')
    stretchr.transporter.responses << test_response

    response_from_get = stretchr.people(123).get

    assert_equal(test_response, response_from_get, "response from get should be the response form the transporter")
    
    if assert_equal(1, stretchr.transporter.requests.length)
      
      request = stretchr.transporter.requests[0]
      
      assert_equal(:get, request.http_method, "http_method")
      assert_nil(request.body, "body")
      assert_equal("http://project.company.stretchr.com/api/v1/people/123?%7Ekey=test&%7Esign=a6bfa773f9169dbeae077ba6a8ac3da07fc19db3", request.signed_uri.to_s)

    end

  end

  def test_post

    stretchr = test_stretchr_object

    test_response = Stretchr::Response.new(:json => '{"~s":200,"~d":{"name":"Ryan"}}')
    stretchr.transporter.responses << test_response

    response_from_post = stretchr.people(123).body({:name=>"Ryan"}).post

    assert_equal(response_from_post, test_response, "response from get should be the response form the transporter")
    
    if assert_equal(1, stretchr.transporter.requests.length)
      
      request = stretchr.transporter.requests[0]
      
      assert_equal(:post, request.http_method, "http_method")
      assert_equal(request.body, {:name=>"Ryan"}.to_json)
      assert_equal("http://project.company.stretchr.com/api/v1/people/123?%7Ekey=test&%7Esign=a2c48a40179fdd9db12f157d289e9ec79b00fe04", request.signed_uri.to_s)

    end

  end

  def test_put

    stretchr = test_stretchr_object

    test_response = Stretchr::Response.new(:json => '{"~s":200,"~d":{"name":"Ryan"}}')
    stretchr.transporter.responses << test_response

    response_from_put = stretchr.people(123).body({:name=>"Mat"}).put

    assert_equal(response_from_put, test_response, "response from get should be the response form the transporter")
    
    if assert_equal(1, stretchr.transporter.requests.length)
      
      request = stretchr.transporter.requests[0]
      
      assert_equal(:put, request.http_method, "http_method")
      assert_equal(request.body, {:name=>"Mat"}.to_json)
      assert_equal("http://project.company.stretchr.com/api/v1/people/123?%7Ekey=test&%7Esign=837147f09451a998c041c328821c6b72f88f3336", request.signed_uri.to_s)

    end

  end

  def test_delete

    stretchr = test_stretchr_object

    test_response = Stretchr::Response.new(:json => '{"~s":200,"~d":{"name":"Ryan"}}')
    stretchr.transporter.responses << test_response

    response_from_delete = stretchr.people(123).delete

    assert_equal(response_from_delete, test_response, "response from get should be the response form the transporter")
    
    if assert_equal(1, stretchr.transporter.requests.length)
      
      request = stretchr.transporter.requests[0]
      
      assert_equal(:delete, request.http_method, "http_method")
      assert_nil(request.body, "body")
      assert_equal("http://project.company.stretchr.com/api/v1/people/123?%7Ekey=test&%7Esign=7becba6ba04d40b7dd19408776f7f028c0d8f864", request.signed_uri.to_s)

    end

  end

end
