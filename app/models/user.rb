#if g = Gem.source_index.find_name('ccls-ccls_engine').last
#require 'ccls_engine'
#require g.full_gem_path + '/app/models/user'
#end
#
#User.class_eval do
#	== requires
#	*	uid (unique)
#
#	== accessible attributes
#	*	sn
#	*	displayname
#	*	mail
#	*	telephonenumber
#class User < ActiveRecord::Base
class User < Ccls::User

#	ucb_authenticated

	%w(	home_page_pics ).each do |resource|
		alias_method "may_create_#{resource}?".to_sym,  :may_edit?
		alias_method "may_read_#{resource}?".to_sym,    :may_edit?
		alias_method "may_edit_#{resource}?".to_sym,    :may_edit?
		alias_method "may_update_#{resource}?".to_sym,  :may_edit?
		alias_method "may_destroy_#{resource}?".to_sym, :may_edit?
	end

end
