#	== requires
#	*	uid (unique)
#
#	== accessible attributes
#	*	sn
#	*	displayname
#	*	mail
#	*	telephonenumber
class User < ActiveRecord::Base

	ucb_authenticated

#	alias_method :may_view_home_page_pics?, :may_edit?
#	alias_method :may_view_calendar?,       :may_read?

end
