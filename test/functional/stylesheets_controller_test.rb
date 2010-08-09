require File.dirname(__FILE__) + '/../test_helper'

class StylesheetsControllerTest < ActionController::TestCase

	test "should get dynamic" do
		get 'dynamic', :format => 'css'
		assert_response :success
		assert_not_nil @response.body.match(/some_unlikely_dynamic_tag/)
	end

end
