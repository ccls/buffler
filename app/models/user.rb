#	== requires
#	*	uid (unique)
#
#	== accessible attributes
#	*	sn
#	*	displayname
#	*	mail
#	*	telephonenumber
class User < Calnet::User

#	%w(	home_page_pics ).each do |resource|
#		alias_method "may_create_#{resource}?".to_sym,  :may_edit?
#		alias_method "may_read_#{resource}?".to_sym,    :may_edit?
#		alias_method "may_edit_#{resource}?".to_sym,    :may_edit?
#		alias_method "may_update_#{resource}?".to_sym,  :may_edit?
#		alias_method "may_destroy_#{resource}?".to_sym, :may_edit?
#	end

end
