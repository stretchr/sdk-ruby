require "test_helper"

describe "Param Bag" do
	it "should let me set basic parameters" do
		b = Stretchr::Bag.new
		b.set("param", "value")
		assert_equal "value", b.get("param")
	end
end