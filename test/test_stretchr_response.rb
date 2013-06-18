require 'test/unit'
require 'test_helper.rb'

class StretchrResponseTest < Test::Unit::TestCase

  def test_new_with_json

    json_string = '{"~s":200,"~d":{"name":"Ryan"},"~x":"123","~e":[{"~m":"Something went wrong"}]}'
    r = Stretchr::Response.new(:json => json_string)

    assert_equal(json_string, r.json_string)
    assert_equal(200, r.json_object["~s"])

    assert_equal(200, r.status)
    assert_equal("123", r.client_context)
    assert_equal("Ryan", r.data["name"])
    assert_equal(1, r.errors.length)
    assert_equal("Something went wrong", r.errors[0])

  end

  def test_change_info
    json_string = '{"~s":200, "~ch" : {"~deltas" : "test"}}'
    r = Stretchr::Response.new(:json => json_string)
    assert_equal r.changed, "test", "Should have grabbed the change info"
      
  end

  def test_was_successful
    json_string = '{"~s":200,"~d":{"name":"Ryan"},"~x":"123","~e":[{"~m":"Something went wrong"}]}'
    r = Stretchr::Response.new(:json => json_string)
    assert_equal true, r.success?, "200 success"

    json_string = '{"~s":201,"~d":{"name":"Ryan"},"~x":"123","~e":[{"~m":"Something went wrong"}]}'
    r = Stretchr::Response.new(:json => json_string)
    assert_equal true, r.success?, "201 success"

    json_string = '{"~s":404,"~d":{"name":"Ryan"},"~x":"123","~e":[{"~m":"Something went wrong"}]}'
    r = Stretchr::Response.new(:json => json_string, :supress_errors => true)
    assert_equal false, r.success?, "404 success"

    json_string = '{"~s":500,"~d":{"name":"Ryan"},"~x":"123","~e":[{"~m":"Something went wrong"}]}'
    r = Stretchr::Response.new(:json => json_string, :supress_errors => true)
    assert_equal false, r.success?, "500 success"
  end

end