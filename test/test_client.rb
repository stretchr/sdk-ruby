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

	it "Should let me specify the project and key" do
		stretchr = Stretchr::Client.new({project: "asdf", key: "asdf2"})
		assert_equal "asdf", stretchr.project, "Should have let me pass in the project"
		assert_equal "asdf2", stretchr.key, "Should have let me pass in the key"
	end

	it "Should pass the client to the request" do
		stretchr = Stretchr::Client.new({project: "asdf", api_version: "v1.1"})
		r = stretchr.people
		assert_equal stretchr, r.client, "Should have passed the client into the request"
	end

	it "Shoudl let me specify the account" do
		stretchr = Stretchr::Client.new({account: "ryan"})
		assert_equal "ryan", stretchr.account, "Should have let me set the account"
	end

	it "Should have a default api_version" do
		stretchr = Stretchr::Client.new
		assert stretchr.api_version, "Should have set a default api version"
	end

	it "Should let me specify the hostname I want" do
		stretchr = Stretchr::Client.new({hostname: "ryon.com"})
		assert_equal "ryon.com", stretchr.hostname, "Should have let me specify the hostname I want"
	end

	it "Should default to the stretchr hostname" do
		stretchr = Stretchr::Client.new
		assert_equal 'stretchr.com', stretchr.hostname, "Should have defaulted to the correct hostname"
	end

	it "Should set a default transporter if I don't" do
		stretchr = Stretchr::Client.new
		assert_equal Stretchr::JSONTransporter, stretchr.transporter.class, "Should have defaulted to JSON transport"
	end

	it "Should accept a new hostname as valid" do
		stretchr = Stretchr::Client.new({account: "asdf", project: "asdf", key: "asdf", hostname: "stretchr.it"})
		url = stretchr.collection.to_url
		assert_equal "https://asdf.stretchr.it/api/v1.1/asdf/collection?key=asdf", url, "Expected the URLs to match"
	end

	it "Should let me use http" do
		#default to true
		stretchr = Stretchr::Client.new
		assert_equal true, stretchr.use_ssl, "Should have default to true for ssl"
		stretchr = Stretchr::Client.new({account: "asdf", project: "asdf", key: "asdf", use_ssl: false})
		url = stretchr.collection.to_url
		assert_equal false, stretchr.use_ssl, "Should have stored the ssl preference"
		assert_equal "http://asdf.stretchr.com/api/v1.1/asdf/collection?key=asdf", url, "Should have set the url to http"
	end


end