require 'test_helper'

class CalendarsControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = { :actions => [:show] }

	assert_access_with_login({ :skip_show_failure => true, :logins => site_readers })
	assert_no_access_with_login( :logins => non_site_readers )
	assert_no_access_without_login 
	assert_access_with_https 
	assert_no_access_with_http

end
