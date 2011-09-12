require 'test_helper'

class CalendarsControllerTest < ActionController::TestCase

	assert_access_with_login       :show, { 
		:skip_show_failure => true,
		:logins => [:superuser,:admin,:editor,:interviewer,:reader] }
	assert_no_access_with_login    :show, { 
		:logins => [:active_user] }
	assert_no_access_without_login :show

	assert_access_with_https   :show
	assert_no_access_with_http :show

end
