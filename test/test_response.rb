require "test_helper"

describe "Response" do
	it "Should take in and store a response" do
		d = {name: "ryon"}.to_json
		r = Stretchr::Response.new(d)
		assert_equal d, r.raw, "Should have saved the raw response"
	end

	it "Should know if the response was successfull" do
		r = Stretchr::Response.new(load_api_response("get_collection_response.json"))
		assert r.success?, "Should have registered response as success"
	end

	it "Should parse out the json data" do
		d = {name: "ryon"}.to_json
		r = Stretchr::Response.new(d)
		assert_equal "ryon", r.parsed["name"], "Should have parsed out the data"
	end

	it "Should no how to pull out data from a stretchr response" do
		r = Stretchr::Response.new(load_api_response("get_single_response.json"))
		assert_equal "value", r.data["field"], "Should have pulled actual data from stretchr standard response"
	end

	it "Should let me specify my own api_version" do
		d = {name: "ryon"}.to_json
		r = Stretchr::Response.new(d, {api_version: "v2"})
		assert_equal "v2", r.api_version, "Should have let me specify the api version"
	end

	it "Should know how to extract errors out" do
		r = Stretchr::Response.new(load_api_response("not_found_error.json"))
		assert_equal false, r.success?, "Should have registered as a failure"
		assert_equal "one", r.errors.first["~message"], "Should have returned the errors as an array"
	end

	it "Should be able to return the changes" do
		r = Stretchr::Response.new(load_api_response("post_single_object.json"))
		assert_equal 1, r.changes["~created"], "Should have returned the changes"
	end
end