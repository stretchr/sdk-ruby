require 'test/unit'
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

	def test_basic_url_generation
		stretchr = Stretchr.new({private_key: 'ABC123-private', public_key: "test", project: "project.company"})
		assert_equal "http://project.company.stretchr.com/api/v1/people/1/cars", stretchr.people(1).cars.to_url
	end

	def test_filters
		skip
	end

	def test_paging
		stretchr = Stretchr.new({private_key: 'ABC123-private', public_key: "test", project: "project.company"})
		assert_equal stretchr.people.limit(10).skip(10).to_url, "http://project.company.stretchr.com/api/v1/people?~limit=10&~skip=10"

		stretchr = Stretchr.new({private_key: 'ABC123-private', public_key: "test", project: "project.company"})
		assert_equal stretchr.people.limit(10).page(2).to_url, "http://project.company.stretchr.com/api/v1/people?~limit=10&~skip=10"
	end

	def test_orders
		stretchr = Stretchr.new({private_key: 'ABC123-private', public_key: "test", project: "project.company"})
		assert_equal stretchr.people.order("-age").to_url, "http://project.company.stretchr.com/api/v1/people?~order=-age"

		stretchr = Stretchr.new({private_key: 'ABC123-private', public_key: "test", project: "project.company"})
		assert_equal stretchr.people.order("-age,name").to_url, "http://project.company.stretchr.com/api/v1/people?~order=-age,name"
	end

	def test_signature_output
		skip "TODO"
		#assert_equal "df073ee4086eed5848d167871c7424937027728e", Stretchr::Security.signature({url: "http://test.stretchr.com/api/v1?~key=ABC123&:name=!Mat&:name=!Laurie&:age=>20", method: "GET", body: "body", privae_key: "ABC123-private"})
	
	end

end