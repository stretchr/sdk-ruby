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
		response = Stretchr::GenerateResponse.get_collection_response
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
		assert_equal ({name: "Ryan"}).to_json, Account.stretchr_client.transporter.requests.last.body, "Should have set the correct body"
		assert account.stretchr_id != nil, "Should have returned and set a stretchr id"
	end

	def test_save_new_object_with_id
		account = Account.new
		account.name = "Ryan"
		account.stretchr_id = "ryan"

		response = Stretchr::GenerateResponse.post_response
		Account.load_response(response)

		account.save
		assert JSON.parse(Account.stretchr_client.transporter.requests.last.body).has_key?("~id"), "Should have set the stretchr id for me!"
	end

	def test_save_old_project
		flunk "not implemented"
	end

	def test_create_method
		response = Stretchr::GenerateResponse.post_response({deltas: [{"~id" => "asdf"}]})
		Account.load_response(response)

		account = Account.create({name: "Ryan"})
		assert_equal "Ryan", account.name, "Should have created the object with the attributes"
		assert_equal "asdf", account.stretchr_id, "Should have given it a stretchr ID from the response"

		response = Stretchr::GenerateResponse.post_response({deltas: [{"~id" => "ryan"}, {"~id" => "tim"}]})
		Account.load_response(response)

		accounts = Account.create([{name: "Ryan"}, {name: "Tim"}])
		assert_equal "ryan", accounts.first.stretchr_id, "Should have returned an array of objects"
		assert_equal "tim", accounts[1].stretchr_id, "Second object should work!"
	end

	def test_create_with_id
		response = Stretchr::GenerateResponse.post_response({deltas: [{"~id" => "asdf"}]})
		Account.load_response(response)

		account = Account.create({name: "Ryan", stretchr_id: "ryan-id"})

		assert Account.stretchr_client.transporter.requests.last.body.include?("~id"), "Should have set the ~id for stretchr"
	end

	def test_not_found
		response = Stretchr::GenerateResponse.get_single_response({status: 404})
		Account.load_response(response)
		account = Account.find({id: "ryan"})
		assert_equal false, account, "Should have returned false if object not found"
	end

	def test_find_resources
		response = Stretchr::GenerateResponse.get_collection_response({objects: [{name: "Ryan", "~id" => "ryan"}, {name: "Ryan", "~id" => "tim"}]})
		Account.load_response(response)
		accounts = Account.where("name" => "Ryan")
		assert accounts.length == 2, "should have returned two objects"
		assert accounts.first.is_a?(Account), "should have returned an array of account objects"
		assert accounts.first.name == "Ryan", "should have returned editable objects"
	end

	def test_find_no_resources
		response = Stretchr::GenerateResponse.get_collection_response
		Account.load_response(response)
		accounts = Account.where("name" => "Ryan")
		assert_equal false, accounts, "Should have returned false for no objects!"
	end

	def test_remove_params_from_path
		response = Stretchr::GenerateResponse.get_collection_response({objects: [], in_response: 0})
		Account.load_response(response)
		accounts = Account.where({id: "test"})
		last_uri = Account.stretchr_client.transporter.requests.last.signed_uri
		assert last_uri.path.include?("/books/test"), "Should have set the path"
		assert !URI.decode(last_uri.query).include?(":id"), "Should not have included id search in query"
	end

	def test_nil_path_param
		assert_nothing_raised "Nil attributes shouldn't raise error" do
			Stretchr::Resource.instance_eval { prep_path("/accounts/:account_id", {account_id: nil}) }
		end
	end

	def test_number_for_param
		assert_nothing_raised "Nil attributes shouldn't raise error" do
			Stretchr::Resource.instance_eval { prep_path("/accounts/:account_id", {account_id: 123}) }
		end
	end

	def test_to_json
		account = Account.new
		account.name = "Ryan"
		account.stretchr_id = "asdf"
		hash = {"name" => "Ryan", "stretchr_id" => "asdf"}
		assert_equal hash, account.to_hash, "Should have returned a hash"
		assert_equal hash.to_json, account.to_json, "Should have returned json"
	end

	#FIXME : It needs to know when an item already exists and when it's being created for the first time and handle them appropriately
	#FIXME : It needs to be able to throw errors for 404, etc...
	#FIXME : Should test "where" with params in the path as well.  It should add them to the path but remove them from the query

end
