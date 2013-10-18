require "test_helper"

describe "Response" do
	it "Should take in and store a response" do
		r = Stretchr::Response.new("test")
		assert_equal "test", r.raw, "Should have saved the raw response"
	end

	it "Should know if the response was successfull" do
		flunk
	end
end