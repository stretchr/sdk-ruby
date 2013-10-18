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

	it "Should let me specify an api version" do
		r = Stretchr::Request.new({api_version: "v1.1"})
		assert_equal "v1.1", r.api_version, "Should let me specify an api version"
	end

	it "Should know how to build a complete url including path" do
		r = Stretchr::Request.new({base_url: "project.stretchr.com", api_version: "v1.1"})
		assert_equal "https://project.stretchr.com/api/v1.1/people/1/cars", r.people(1).cars.to_url, "Should have built the url properly"
	end

	it "Should let you pass in params" do
		r = Stretchr::Request.new({base_url: "project.stretchr.com"})
		r.param("key", "asdf")
		assert r.to_url.include?("?key=asdf"), "Should have added the params"
	end

	it "should let you chain params" do
		r = Stretchr::Request.new({base_url: "project.stretchr.com"})
		r.param("key", "asdf").param("key2", "asdf2")
		uri = r.to_uri
		assert_equal "asdf", uri.get_param("key").first, "should have set key"
		assert_equal "asdf2", uri.get_param("key2").first, "Should have set key2"
	end

	it "should let you add filters" do
		r = Stretchr::Request.new({base_url: "project.stretchr.com", api_version: "v1.1"})
		r.where("name", "ryan").where("age", "21")
		assert_equal ["ryan"], r.to_uri.get_param(":name"), "Should have added filters"
		assert_equal ["21"], r.to_uri.get_param(":age"), "Should have added filter for age"
	end

	it "Should let you add multiple filters" do
		r = Stretchr::Request.new({base_url: "project.stretchr.com"})
		r.where("age", [">21", "<40"])
		assert_equal [">21", "<40"], r.to_uri.get_param(":age"), "Should have added multiple ages"
	end

	it "Should let you get objects" do
		t = Stretchr::TestTransporter.new
		r = Stretchr::Request.new({base_url: "project.stretchr.com", transporter: t})
		r.people.get
		assert_equal :get, t.requests.first[:method], "Should have performed a get request"
	end

	it "Should let you create new objects" do
		t = Stretchr::TestTransporter.new
		r = Stretchr::Request.new({base_url: "project.stretchr.com", transporter: t})
		r.people.create({name: "ryan"})
		assert_equal :post, t.requests.first[:method], "Should have performed a post"
		assert_equal "ryan", t.requests.first[:body][:name], "Should have sent the body to the transporter"
	end
end