require "test_helper"

describe "Load Config" do
	it "Should load the config file for you" do
		assert_equal "~status", Stretchr.config["v1.1"]["status"], "Should have loaded the config file"
	end
end