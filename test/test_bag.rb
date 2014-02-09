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
		assert_equal "include=~parent&key=asdf", URI.decode(b.query_string), "Should let you create a query string"
	end

	it "Should let me specify a key to start the bag with" do
		b = Stretchr::Bag.new({prefix: ":"})
		b.set("age", "21")
		assert_equal "21", b.get("age"), "Should have set the age"
		assert_equal ":age=21", URI.decode(b.query_string), "Should have added a prefix to the bag"
	end

	it "Should let me pass in a hash of parameters" do
		b = Stretchr::Bag.new
		b.set({name: "ryan", age: 26})
		assert_equal "ryan", b.get("name"), "should have set the name"
		assert_equal 26, b.get("age"), "should have set the age"
	end

	it "Shouldn't care about symbols and strings" do
		b = Stretchr::Bag.new
		b.set("name", "ryan")
		b.set(:age, 21)
		assert_equal "ryan", b.get(:name), "Shouldn't have cared"
		assert_equal 21, b.get("age"), "shouldn't have cared"
	end
end