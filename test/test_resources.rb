require 'test/unit'
require 'test_helper.rb'

class ResourcesTest < Test::Unit::TestCase
	Stretchr.config do |s|
		s.project = "test"
		s.private_key = "test"
		s.public_key = "test"
	end

	class Account < Stretchr::Resource
		stretchr_config :path => "/books"
	end

	def test_ghost_methods
		resource = Stretchr::Resource.new
		resource.name = "Ryan"
		assert_equal resource.name, "Ryan", "Should be able to create any attributes for a resource"
	end

	def test_resources_build_clients
		resource = Stretchr::Resource.new
		assert_equal resource.stretchr_client.class, Stretchr::Client, "Client should exist for Resources"
	end

	def test_resources_set_paths
		account = Account.new
		assert_equal account.stretchr_client.path, "/books"
	end

end
