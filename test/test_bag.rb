require "test_helper"

describe "Param Bag" do
	it "should let me set basic parameters" do
		b = Stretchr::Bag.new
		b.set("param", "value")
		assert_equal "value", b.get("param")
	end

	it "Should let you merge parameters into a query string" do
		b = Stretchr::Bag.new
		b.set("include", "~parent")
		b.set("key", "asdf")
		assert_equal "include=~parent&key=asdf", b.query_string, "Should let you create a query string"
	end
end