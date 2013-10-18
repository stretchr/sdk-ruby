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
end