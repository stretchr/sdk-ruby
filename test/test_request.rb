require "test_helper"

describe "Request Object" do
	it "Should let you build up a url" do
		r = Stretchr::Request.new
		r.people(1).cars
		assert_equal "people/1/cars", r.path, "Should have built up a path"
	end

	it "Should let me specify a base url" do
		r = Stretchr::Request.new({base_url: "https://project.stretchr.com/api/v1.1/"})
		assert_equal "https://project.stretchr.com/api/v1.1/", r.base_url, "Should let me specify the base url"
	end

	it "Should know how to build a complete url including path" do
		r = Stretchr::Request.new({base_url: "https://project.stretchr.com/api/v1.1/"})
		assert_equal "https://project.stretchr.com/api/v1.1/people/1/cars", r.people(1).cars.to_url, "Should have built the url properly"
	end
end