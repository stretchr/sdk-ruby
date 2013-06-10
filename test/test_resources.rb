require 'test/unit'
require 'test_helper.rb'

class ResourcesTest < Test::Unit::TestCase
	Stretchr.config do |s|
		s.project = "test"
		s.private_key = "test"
		s.public_key = "test"
	end

	class Account < Stretchr::Resource
		stretchr_config path: "/books/:id", transporter: Stretchr::TestTransporter.new

		def self.load_response(response)
			self.stretchr_client.transporter.responses << Stretchr::Response.new({json: response})
		end
	end

	def test_ghost_methods
		resource = Stretchr::Resource.new
		resource.name = "Ryan"
		assert_equal resource.name, "Ryan", "Should be able to create any attributes for a resource"
	end

	def test_resources_build_clients
		assert_equal Stretchr::Resource.stretchr_client.class, Stretchr::Client, "Client should exist for Resources"
		assert_equal Account.stretchr_client.path, "/books/:id"
	end

	def test_strip_tildes
		account = Account.new({"~id" => "test"})
		assert_equal "test", account.stretchr_id, "Should have stripped the tilde"
	end

	def test_can_find_resources
		response = Stretchr::GenerateResponse.get_single_response({status: 200, data: {"~id" => "test", name: "Ryan"}})
		Account.load_response(response)
		account = Account.find({:id => "test"})
		assert_equal Account, account.class, "Should have returned an account object"
		assert_equal "Ryan", account.name, "Should have returned the data attributes as methods"
	end

	def test_can_get_all_resources
		response = Stretchr::GenerateResponse.get_collection_response({objects: [{name: "Ryan", "~id" => "ryan"}, {name: "Tim", "~id" => "tim"}]})
		Account.load_response(response)
		accounts = Account.all
		assert_equal "/books/", Account.stretchr_client.transporter.requests.last.signed_uri.path.gsub(/\/api\/v[0-9]*/, "") #gsub to trim out the /api/v1 bit
		assert_equal accounts.first.class, Account, "Should have returned an array of account objects"
		assert_equal accounts.first.name, "Ryan", "Should have returned the data for each object"
	end

	def test_single_from_all
		response = Stretchr::GenerateResponse.get_collection_response({objects: [{name: "Ryan", "~id" => "ryan"}]})
		Account.load_response(response)
		accounts = Account.all
		assert accounts.is_a?(Array), "Should return an array even for a single response"
	end

	def test_none_from_all
		response = Stretchr::GenerateResponse.get_collection_response({objects: []})
		Account.load_response(response)
		accounts = Account.all
		assert accounts.is_a?(Array), "Should return an array even for zero objects"
	end

	def test_save_new_object
		account = Account.new
		account.name = "Ryan"

		response = Stretchr::GenerateResponse.post_response({deltas: {"~id" => "asdf"}})
		Account.load_response(response)

		account.save

		assert account.stretchr_id != nil, "Should have returned and set a stretchr id"
	end

	def test_save_new_object_with_id
		flunk "not implemented"
	end

	def test_save_old_project
		flunk "not implemented"
	end

	#FIXME : It needs to know when an item already exists and when it's being created for the first time and handle them appropriately
	#FIXME : It needs to be able to throw errors for 404, etc...
	

end
