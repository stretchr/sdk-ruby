require 'test/unit'
require 'test_helper.rb'
require 'stretchr'

class StretchrTest < Test::Unit::TestCase

	def test_new_with_missing_fields
		assert_raise Stretchr::MissingAttributeError do
			stretchr = Stretchr.new({})
		end
		assert_raise Stretchr::MissingAttributeError do
			stretchr = Stretchr.new({public_key: "test", project: "project.company"})
		end
		assert_raise Stretchr::MissingAttributeError do
			stretchr = Stretchr.new({private_key: 'ABC123-private', project: "project.company"})
		end
		assert_raise Stretchr::MissingAttributeError do
			stretchr = Stretchr.new({private_key: 'ABC123-private', public_key: "test"})
		end

	end

	def test_new_defaults

		stretchr = Stretchr.new({private_key: 'ABC123-private', public_key: "test", project: "project.company"})
		assert_not_nil stretchr.signatory, "stretchr.signatory"
		assert_not_nil stretchr.transporter, "stretchr.transporter"

	end

	def test_new_custom_transporter

		transporter = Object.new
		stretchr = Stretchr.new({transporter: transporter, private_key: 'ABC123-private', public_key: "test", project: "project.company"})
		assert_equal transporter, stretchr.transporter

	end

	def test_new_custom_signatory

		signatory = Object.new
		stretchr = Stretchr.new({signatory: signatory, private_key: 'ABC123-private', public_key: "test", project: "project.company"})
		assert_equal signatory, stretchr.signatory

	end

	def test_make_request

		stretchr = Stretchr.new({private_key: 'ABC123-private', public_key: "test", project: "project.company"})
		stretchr.people(123).books
		
		stretchr.http_method = :get

		request = stretchr.generate_request

		assert_equal true, request.is_a?(Stretchr::Request)

		assert_equal(stretchr.http_method, request.http_method)
		assert_equal(stretchr.signed_uri, request.signed_uri)

	end

	def test_basic_url_generation
		stretchr = Stretchr.new({private_key: 'ABC123-private', public_key: "test", project: "project.company"})
		assert_equal URI.parse("http://project.company.stretchr.com/api/v1/people/1/cars").to_s, stretchr.people(1).cars.to_url
	end

	def test_paging
		stretchr = Stretchr.new({private_key: 'ABC123-private', public_key: "test", project: "project.company"})
		stretchr.people.limit(10).skip(10)
		assert_equal true, stretchr.uri.validate_param_value("~limit", "10"), "limit not set"
		assert_equal true, stretchr.uri.validate_param_value("~skip", "10"), "skip not set"

		stretchr = Stretchr.new({private_key: 'ABC123-private', public_key: "test", project: "project.company"})
		stretchr.people.limit(10).page(2)
		assert_equal true, stretchr.uri.validate_param_value("~limit", "10"), "limit not set"
		assert_equal true, stretchr.uri.validate_param_value("~skip", "10"), "skip not set"
	end

	def test_orders
		stretchr = Stretchr.new({private_key: 'ABC123-private', public_key: "test", project: "project.company"})
		stretchr.people.order("-age")
		assert_equal true, stretchr.uri.validate_param_value("~order", "-age")

		stretchr = Stretchr.new({private_key: 'ABC123-private', public_key: "test", project: "project.company"})
		stretchr.people.order("-age,name")
		assert_equal true, stretchr.uri.validate_param_value("~order", "-age,name")
	end

	def test_signed_uri

		stretchr = Stretchr.new({private_key: 'ABC123-private', public_key: "test", project: "project.company"})
		stretchr.people(123).books

		assert_equal(true, stretchr.signed_uri.validate_param_presence("~sign"), "~sign param expected")

	end

	def test_signing
		public_key = "ABC123"
		private_key = "ABC123-private"
		body = "body"
		url = "http://test.stretchr.com/api/v1?:name=!Mat&:name=!Laurie&:age=>20"

		#as per documentation
		assert_equal true, Stretchr::Signatory.generate_signed_url("get", url, public_key, private_key, body).validate_param_value("~sign", "6c3dc03b3f85c9eb80ed9e4bd21e82f1bbda5b8d"), "URL signature didn't match expected"
	end

	def test_signing_with_no_query
		public_key = "ABC123"
		private_key = "ABC123-private"
		body = "body"
		url = "http://test.stretchr.com/api/v1"

		#as per documentation
		assert_equal true, Stretchr::Signatory.generate_signed_url("get", url, public_key, private_key, body).validate_param_value("~sign", "d5e1dcbba794be7dc6767076bd4747b51837f21d"), "URL signature didn't match expected"
	end

	def test_private_key_and_body_hash_removal
		#we shouldn't see the private key or body hash in the final url
		public_key = "ABC123"
		private_key = "ABC123-private"
		body = "body"
		url = "http://test.stretchr.com/api/v1?:name=!Mat&:name=!Laurie&:age=>20"

		assert_equal false, Stretchr::Signatory.generate_signed_url("get", url, public_key, private_key, body).validate_param_presence("~private"), "private param included"
		assert_equal false, Stretchr::Signatory.generate_signed_url("get", url, public_key, private_key, body).validate_param_presence("~bodyhash"), "private param included"
	end

end