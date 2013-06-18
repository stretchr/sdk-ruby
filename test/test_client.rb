require 'test/unit'
require 'test_helper.rb'

class StretchrTest < Test::Unit::TestCase

	def test_new_with_missing_fields
		assert_raise Stretchr::MissingAttributeError do
			stretchr = Stretchr::Client.new({})
		end
		assert_raise Stretchr::MissingAttributeError do
			stretchr = Stretchr::Client.new({public_key: "test", project: "project.company"})
		end
		assert_raise Stretchr::MissingAttributeError do
			stretchr = Stretchr::Client.new({private_key: 'ABC123-private', project: "project.company"})
		end
		assert_raise Stretchr::MissingAttributeError do
			stretchr = Stretchr::Client.new({private_key: 'ABC123-private', public_key: "test"})
		end

	end

	def test_new_defaults

		stretchr = test_stretchr_object
		assert_not_nil stretchr.signatory, "stretchr.signatory"
		assert_not_nil stretchr.transporter, "stretchr.transporter"

	end

	def test_new_custom_transporter

		transporter = Object.new
		stretchr = Stretchr::Client.new({transporter: transporter, private_key: 'ABC123-private', public_key: "test", project: "project.company"})
		assert_equal transporter, stretchr.transporter

	end

	def test_new_custom_signatory

		signatory = Object.new
		stretchr = Stretchr::Client.new({signatory: signatory, private_key: 'ABC123-private', public_key: "test", project: "project.company"})
		assert_equal signatory, stretchr.signatory

	end

	def test_make_request

		stretchr = test_stretchr_object
		stretchr.people(123).books
		
		stretchr.http_method = :get

		request = stretchr.generate_request

		assert_equal true, request.is_a?(Stretchr::Request)

		assert_equal(stretchr.http_method, request.http_method)
		assert_equal(stretchr.signed_uri, request.signed_uri)

	end

	def test_basic_url_generation
		stretchr = test_stretchr_object
		assert_equal URI.parse("http://project.company.stretchr.com/api/v1/people/1/cars").to_s, stretchr.people(1).cars.to_url
	end

	def test_paging
		stretchr = test_stretchr_object
		stretchr.people.limit(10).skip(10)
		assert_equal true, stretchr.uri.validate_param_value("~limit", "10"), "limit not set"
		assert_equal true, stretchr.uri.validate_param_value("~skip", "10"), "skip not set"

		stretchr = test_stretchr_object
		stretchr.people.limit(10).page(2)
		assert_equal true, stretchr.uri.validate_param_value("~limit", "10"), "limit not set"
		assert_equal true, stretchr.uri.validate_param_value("~skip", "10"), "skip not set"
	end

	def test_orders
		stretchr = test_stretchr_object
		stretchr.people.order("-age")
		assert_equal true, stretchr.uri.validate_param_value("~order", "-age")

		stretchr = test_stretchr_object
		stretchr.people.order("-age,name")
		assert_equal true, stretchr.uri.validate_param_value("~order", "-age,name")
	end

	def test_configuration_setup
		Stretchr.config do |s|
			s.private_key = "test_private"
			s.public_key = "test_public"
			s.project = "test"
		end

		assert_equal Stretchr.instance_eval {@configuration.private_key}, "test_private", "Should have setup configuration for the module"
		assert_nothing_raised do
			client = Stretchr::Client.new
		end

		assert_raise Stretchr::UnknownConfiguration, "Should raise an error when we pass an unknown configuration in" do
			Stretchr.config do |s|
				s.fake_param = "what"
			end
		end
		#FIXME : this is a hack to reset the client!
		Stretchr.instance_eval {@configuration = Stretchr::Configuration.new}
	end

	def test_client_shouldnt_expect_options
		assert_nothing_raised do
			client = Stretchr::Client.new(nil)
		end
	end

	def test_client_should_raise_errors
		stretchr = test_stretchr_object
		stretchr.noisy_errors = true
		assert_raises Stretchr::NotFound, "Should have returned not found!" do
			stretchr.transporter.responses << Stretchr::Response.new({json: ({"~s" => 404}).to_json})
			stretchr.get
		end
	end

	def test_query
		stretchr = test_stretchr_object
		stretchr.where("name" => "ryan", "age" => ">21")
		assert stretchr.uri.validate_param_value(":name", "ryan"), "Should have searched for a name"
		assert stretchr.uri.validate_param_value(":age", ">21"), "Should search for an age"
	end

end