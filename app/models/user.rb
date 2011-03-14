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
class User < Calnet::User

#	calnet_authenticated

#	def self.search(options={})
#		conditions = {}
#		includes = joins = []
#		if !options[:role_name].blank?
#			includes = [:roles]
#			if Role.all.collect(&:name).include?(options[:role_name])
#				joins = [:roles]
##				conditions = ["roles.name = '#{options[:role_name]}'"]
#				conditions = ["roles.name = ?",options[:role_name]]
#	#		else
#	#			@errors = "No such role '#{options[:role_name]}'"
#			end 
#		end 
#		self.all( 
#			:joins => joins, 
#			:include => includes,
#			:conditions => conditions )
#	end 
#
#	#	Find or Create a user from a given uid, and then 
#	#	proceed to update the user's information from the 
#	#	UCB::LDAP::Person.find_by_uid(uid) response.
#	#	
#	#	Returns: user
#	def self.find_create_and_update_by_uid(uid)
#		user = self.find_or_create_by_uid(uid)
#		person = UCB::LDAP::Person.find_by_uid(uid) 
#		user.update_attributes!({
#			:displayname     => person.displayname,
#			:sn              => person.sn.first,
#			:mail            => person.mail.first || '',
#			:telephonenumber => person.telephonenumber.first
#		}) unless person.nil?
#		user
#	end
#
#	#	FYI.  gravatar can't deal with a nil email
#	gravatar :mail, :rating => 'PG'
#
#	#	gravatar.url will include & that are not encoded to &amp;
#	#	which works just fine, but technically is invalid html.
#	def gravatar_url
#		gravatar.url.gsub(/&/,'&amp;')
#	end
#
#	self.default_scoping = []
#
#	validates_presence_of   :uid
#	validates_uniqueness_of :uid
#
#	#	include the many may_*? for use in the controllers
#	authorized
#
#	alias_method :may_create?,  :may_edit?
#	alias_method :may_update?,  :may_edit?
#	alias_method :may_destroy?, :may_edit?

	%w(	home_page_pics ).each do |resource|
		alias_method "may_create_#{resource}?".to_sym,  :may_edit?
		alias_method "may_read_#{resource}?".to_sym,    :may_edit?
		alias_method "may_edit_#{resource}?".to_sym,    :may_edit?
		alias_method "may_update_#{resource}?".to_sym,  :may_edit?
		alias_method "may_destroy_#{resource}?".to_sym, :may_edit?
	end

end
