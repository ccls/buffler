require File.dirname(__FILE__) + '/../test_helper'

module Ccls
class CoreExtensionTest < ActiveSupport::TestCase

	test "this class exists" do
		assert class_exists?('CoreExtensionTest')
	end

	test "non class exists but is not a class" do
		assert !class_exists?('UcbCclsEngineHelper')
	end

	test "bogus class does not exist" do
		assert !class_exists?('SomeBogusClass')
	end

end
end
