require 'test/unit'
require 'test_helper.rb'
require 'stretchr'

class ResourcesTest < Test::Unit::TestCase

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

	def test_signing_again
		public_key = "ABC123"
		private_key = "PRIVATE"
		url = "http://localhost:8080/api/v1?:name=!Mat&:name=!Laurie&:age=>20"

		#as per documentation
		assert_equal "c544d7d9d76d19950bdd7c7e9c93778f52ce7f5e", Stretchr::Signatory.generate_signed_url("get", url, public_key, private_key).get_param("~sign").first, "URL signature didn't match expected"

	end

	def test_signing_with_no_query
		public_key = "ABC123"
		private_key = "ABC123-private"
		body = "body"
		url = "http://test.stretchr.com/api/v1"

		#as per documentation
		assert_equal "d5e1dcbba794be7dc6767076bd4747b51837f21d", Stretchr::Signatory.generate_signed_url("get", url, public_key, private_key, body).get_param("~sign").first, "URL signature didn't match expected"
	end

	def test_signing_with_escapable_characters

		public_key = "ABC123"
		private_key = "PRIVATE"
		url = "http://localhost:8080/api/v1/people?:~created=>10000000"

		#as per documentation
		assert_equal "0ca22ff6daab6ac85978e52ddd8dcac51078b0d4", Stretchr::Signatory.generate_signed_url("get", url, public_key, private_key).get_param("~sign").first, "URL signature didn't match expected"

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