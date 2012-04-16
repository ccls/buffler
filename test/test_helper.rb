ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

require 'calnet_authenticated_test_helper'
require 'simply_authorized_factory_test_helper'
require 'active_support_extension'
require 'action_controller_extension'

class ActiveSupport::TestCase
	fixtures :all

	def self.assert_should_create_default_object
		#       It appears that model_name is a defined class method already in ...
		#       activesupport-####/lib/active_support/core_ext/module/model_naming.rb
		test "should create default #{model_name.sub(/Test$/,'').underscore}" do
			assert_difference( "#{model_name}.count", 1 ) do
				object = create_object
				assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
			end
		end
	end

end

class ActionController::TestCase
	setup :turn_https_on
end



def brand	#	for auto-generated tests
	"@@ "
end
