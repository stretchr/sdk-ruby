require 'test_helper.rb'

describe "Client" do
	it "Should let you pass in the transporter you want" do
		transporter = Object.new
		stretchr = Stretchr::Client.new({transporter: transporter})
		assert_equal transporter, stretchr.transporter, "Should have let me pass in a transporter"
	end

	it "Should return a request object whenever you try to do something" do
		stretchr = Stretchr::Client.new
		r = stretchr.people
		assert_equal Stretchr::Request, r.class, "Should have returned a request object"
		assert_equal "people", r.path, "Should have started building the url"
	end

	it "Should let you specify the version of the api you want to work with" do
		stretchr = Stretchr::Client.new({api_version: "1.1"})
		assert_equal "1.1", stretchr.api_version, "Should let me specify the api version that I want"
	end

	it "Should pass the api version to the request" do
		stretchr = Stretchr::Client.new({api_version: "v1.1"})
		r = stretchr.people
		assert r.base_url.include?("api/v1.1"), "Should have passed the api version to the request"
	end

	it "Should let me specify the project and key" do
		stretchr = Stretchr::Client.new({project: "asdf", key: "asdf2"})
		assert_equal "asdf", stretchr.project, "Should have let me pass in the project"
		assert_equal "asdf2", stretchr.key, "Should have let me pass in the key"
	end

	it "Should pass the project to the request" do
		stretchr = Stretchr::Client.new({project: "asdf", api_version: "v1.1"})
		r = stretchr.people
		assert_equal "https://asdf.stretchr.com/api/v1.1/", r.base_url, "Should have passed the project into the request"
	end


	it "Shoud let me specify a base url for custom stretchr instances"


end