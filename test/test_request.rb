require "test_helper"

describe "Request Object" do
	it "Should let you build up a url" do
		r = Stretchr::Request.new
		r.people(1).cars
		assert_equal "people/1/cars", r.path, "Should have built up a path"
	end

	it "Should know how to build a complete url including path" do
		c = Stretchr::Client.new({account: "ryan", project: "project", api_version: "v1.1"})
		r = Stretchr::Request.new({client: c})
		assert_equal "http://account.stretchr.com/api/v1.1/project/people/1/cars", r.people(1).cars.to_url, "Should have built the url properly"
	end

	it "Should let you pass in params" do
		c = Stretchr::Client.new({project: "project", api_version: "v1.1"})
		r = Stretchr::Request.new({client: c})
		r.param("key", "asdf")
		assert r.to_url.include?("?key=asdf"), "Should have added the params"
	end

	it "should let you chain params" do
		c = Stretchr::Client.new({project: "project", api_version: "v1.1"})
		r = Stretchr::Request.new({client: c})
		r.param("key", "asdf").param("key2", "asdf2")
		uri = r.to_uri
		assert_equal "asdf", uri.get_param("key").first, "should have set key"
		assert_equal "asdf2", uri.get_param("key2").first, "Should have set key2"
	end

	it "should let you add filters" do
		c = Stretchr::Client.new({project: "project", api_version: "v1.1"})
		r = Stretchr::Request.new({client: c})
		r.where("name", "ryan").where("age", "21")
		assert_equal ["ryan"], r.to_uri.get_param(":name"), "Should have added filters"
		assert_equal ["21"], r.to_uri.get_param(":age"), "Should have added filter for age"
	end

	it "Should let you add multiple filters" do
		c = Stretchr::Client.new({project: "project", api_version: "v1.1"})
		r = Stretchr::Request.new({client: c})
		r.where("age", [">21", "<40"])
		assert_equal [">21", "<40"], r.to_uri.get_param(":age"), "Should have added multiple ages"
	end

	it "Should let you get objects" do
		t = Stretchr::TestTransporter.new
		c = Stretchr::Client.new({project: "project", api_version: "v1.1", transporter: t})
		r = Stretchr::Request.new({client: c})
		r.people.get
		assert_equal :get, t.requests.first[:method], "Should have performed a get request"
	end

	it "Should let you create new objects" do
		t = Stretchr::TestTransporter.new
		c = Stretchr::Client.new({project: "project", api_version: "v1.1", transporter: t})
		r = Stretchr::Request.new({client: c})
		r.people.create({name: "ryan"})
		assert_equal :post, t.requests.first[:method], "Should have performed a post"
		assert_equal "ryan", t.requests.first[:body][:name], "Should have sent the body to the transporter"
	end

	it "Should let you replace an existing object" do
		t = Stretchr::TestTransporter.new
		c = Stretchr::Client.new({project: "project", api_version: "v1.1", transporter: t})
		r = Stretchr::Request.new({client: c})
		r.people(1).replace({name: "ryan"})
		assert_equal :put, t.requests.first[:method], "Should have performed a put"
		assert_equal "ryan", t.requests.first[:body][:name], "Should have sent the body to the transporter"
	end

	it "Should let you update an existing object" do
		t = Stretchr::TestTransporter.new
		c = Stretchr::Client.new({project: "project", api_version: "v1.1", transporter: t})
		r = Stretchr::Request.new({client: c})
		r.people(1).update({name: "ryan"})
		assert_equal :patch, t.requests.first[:method], "Should have performed a put"
		assert_equal "ryan", t.requests.first[:body][:name], "Should have sent the body to the transporter"
	end

	it "Should let you remove an object or collection" do
		t = Stretchr::TestTransporter.new
		c = Stretchr::Client.new({project: "project", api_version: "v1.1", transporter: t})
		r = Stretchr::Request.new({client: c})
		r.people(1).remove
		assert_equal :delete, t.requests.first[:method], "Should have performed a put"
	end

	it "Should set a default api version" do
		r = Stretchr::Request.new
		assert r.api_version, "it should have set a default api version"
	end

	it "Should let me pass in a client" do
		client = Object.new
		r = Stretchr::Request.new({client: client})
		assert_equal client, r.client, "Should have passed the client to the request"
	end

	it "Should pass the client to the transporter" do
		t = Stretchr::TestTransporter.new
		c = Stretchr::Client.new({project: "project", api_version: "v1.1", transporter: t})
		r = Stretchr::Request.new({client: c})
		r.people.get
		assert_equal c, t.requests.first[:client], "Should have passed the client to the transporter"
	end

	it "should pass the correct uri to the transporter" do
		t = Stretchr::TestTransporter.new
		c = Stretchr::Client.new({account: "account", project: "project", api_version: "v1.1", transporter: t})
		r = Stretchr::Request.new({client: c})
		r.people.get
		assert_equal "http://account.stretchr.com/api/v1.1/project/people", r.to_url, "Should have saved the right url in the request"
		assert_equal "http://account.stretchr.com/api/v1.1/project/people", t.requests.first[:uri].to_s, "Should have created the right URL and sent it to the transporter"
	end

	it "Should know how to handle paging" do
		c = Stretchr::Client.new({project: "project", api_version: "v1.1"})
		r = Stretchr::Request.new({client: c})
		r.people.limit(10).skip(10)
		assert r.to_uri.validate_param_value("limit", "10"), "should have added limit"
		assert r.to_uri.validate_param_value("skip", "10"), "should have added skip"

		r2 = Stretchr::Request.new({client: c})
		r2.people.limit(10).page(2)
		assert r2.to_uri.validate_param_value("limit", "10"), "should have added limit"
		assert r2.to_uri.validate_param_value("skip", "10"), "should have added skip from paging"
	end

	it "Should understand how to do ordering" do
		c = Stretchr::Client.new({project: "project", api_version: "v1.1"})
		r = Stretchr::Request.new({client: c})
		r.order("-name,age")
		assert r.to_uri.validate_param_value("order", "-name,age"), "should have added order attribute"
	end

	it "Should support the necessary convenience methods" do
		# READ/GET
		t = Stretchr::TestTransporter.new
		c = Stretchr::Client.new({project: "project", api_version: "v1.1", transporter: t})
		r = Stretchr::Request.new({client: c})
		r.people.get
		assert_equal :get, t.requests.first[:method], "Should have performed a get request"
		r.people.read
		assert_equal :get, t.requests[1][:method], "Should have performed a get request"

		# REPLACE/PUT
		t = Stretchr::TestTransporter.new
		c = Stretchr::Client.new({project: "project", api_version: "v1.1", transporter: t})
		r = Stretchr::Request.new({client: c})
		r.people.replace({name: "ryan"})
		assert_equal :put, t.requests.first[:method], "Should have performed a put request"
		r.people.put({name: "ryan"})
		assert_equal :put, t.requests[1][:method], "Should have performed a put request"

		# UPDATE/PATCH
		t = Stretchr::TestTransporter.new
		c = Stretchr::Client.new({project: "project", api_version: "v1.1", transporter: t})
		r = Stretchr::Request.new({client: c})
		r.people.update({name: "ryan"})
		assert_equal :patch, t.requests.first[:method], "Should have performed a patch request"
		r.people.patch({name: "ryan"})
		assert_equal :patch, t.requests[1][:method], "Should have performed a patch request"

		# CREATE/POST
		t = Stretchr::TestTransporter.new
		c = Stretchr::Client.new({project: "project", api_version: "v1.1", transporter: t})
		r = Stretchr::Request.new({client: c})
		r.people.create({name: "ryan"})
		assert_equal :post, t.requests.first[:method], "Should have performed a post request"
		r.people.post({name: "ryan"})
		assert_equal :post, t.requests[1][:method], "Should have performed a post request"

		# REMOVE/DELETE
		t = Stretchr::TestTransporter.new
		c = Stretchr::Client.new({project: "project", api_version: "v1.1", transporter: t})
		r = Stretchr::Request.new({client: c})
		r.people.remove
		assert_equal :delete, t.requests.first[:method], "Should have performed a delete request"
		r.people.delete
		assert_equal :delete, t.requests[1][:method], "Should have performed a delete request"
	end

	it "Should let me set the path manually" do
		c = Object.new
		r = Stretchr::Request.new({client: c})
		assert_equal "people/1/cars", r.at("people/1/cars").path, "Should have set the path completely"
	end
end