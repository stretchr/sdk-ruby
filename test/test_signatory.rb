require 'test/unit'
require 'test_helper.rb'

class ResourcesTest < Test::Unit::TestCase

	def test_signed_uri

		stretchr = test_stretchr_object
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
		assert_equal "6841830bf612b03864edeebf9b99b7f48a8edf2d", Stretchr::Signatory.generate_signed_url("get", url, public_key, private_key).get_param("~sign").first, "URL signature didn't match expected"

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
		assert_equal "b54b16d3542a1497bf22c4f61aa935e81032e7b5", Stretchr::Signatory.generate_signed_url("get", url, public_key, private_key).get_param("~sign").first, "URL signature didn't match expected"

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