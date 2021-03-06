#	== requires
#	*	uid (unique)
#
#	== accessible attributes
#	*	sn
#	*	displayname
#	*	mail
#	*	telephonenumber
class User < ActiveRecord::Base

	validates_presence_of   :uid
	validates_uniqueness_of :uid

	has_and_belongs_to_many :roles,  :uniq => true

	def self.search(options={})
		conditions = {}
		includes = joins = []
		if !options[:role_name].blank?
			includes = [:roles]
			if Role.all.collect(&:name).include?(options[:role_name])
				joins = [:roles]
				conditions = ["roles.name = ?",options[:role_name]]
			end 
		end 
		self.all( 
			:joins => joins, 
			:include => includes,
			:conditions => conditions )
	end 

	#	Find or Create a user from a given uid, and then 
	#	proceed to update the user's information from the 
	#	UCB::LDAP::Person.find_by_uid(uid) response.
	#	
	#	Returns: user
	def self.find_create_and_update_by_uid(uid)
		user = self.find_or_create_by_uid(uid)
		person = UCB::LDAP::Person.find_by_uid(uid) 
		user.update_attributes!({
			:displayname     => person.displayname,
			:sn              => person.sn.first,
			:mail            => person.mail.first || '',
			:telephonenumber => person.telephonenumber.first
		}) unless person.nil?
		user
	end

	def to_s
		displayname
	end

	def role_names
		roles.collect(&:name).uniq
	end

	def may_administrate?(*args)
		(self.role_names & ['superuser','administrator']).length > 0
	end
	alias_method :may_view_permissions?,        :may_administrate?
	alias_method :may_create_user_invitations?, :may_administrate?
	alias_method :may_view_users?,              :may_administrate?
	alias_method :may_assign_roles?,            :may_administrate?

	def may_edit?(*args)
		(self.role_names & 
			['superuser','administrator','editor']
		).length > 0
	end
	alias_method :may_create?,  :may_edit?
	alias_method :may_update?,  :may_edit?
	alias_method :may_destroy?, :may_edit?
	alias_method :may_maintain_pages?, :may_edit?

#	Add tests for may_interview and may_read
	def may_interview?(*args)
		(self.role_names & 
			['superuser','administrator','editor','interviewer']
		).length > 0
	end

#	This is pretty lame as all current roles can read
	def may_read?(*args)
		(self.role_names & 
			['superuser','administrator','editor','interviewer','reader']
		).length > 0
	end
	alias_method :may_view?, :may_read?

	def deputize
		roles << Role.find_or_create_by_name('administrator')
	end

	#	The 4 common CCLS roles are ....
	def is_superuser?(*args)
		self.role_names.include?('superuser')
	end
	alias_method :is_super_user?, :is_superuser?

	def is_administrator?(*args)
		self.role_names.include?('administrator')
	end

	def is_editor?(*args)
		self.role_names.include?('editor')
	end

	def is_interviewer?(*args)
		self.role_names.include?('interviewer')
	end

	def is_reader?(*args)
		self.role_names.include?('reader')
	end

	def is_user?(user=nil)
		!user.nil? && self == user
	end
	alias_method :may_be_user?, :is_user?

	def is_not_user?(user=nil)
		!is_user?(user)
	end
	alias_method :may_not_be_user?, :is_not_user?


	def may_view_user?(user=nil)
		self.is_user?(user) || self.may_administrate?
	end

	def may_share_document?(document=nil)
		document && ( 
			self.is_administrator? ||
			( document.owner && self == document.owner ) 
		)
	end

	def may_view_document?(document=nil)
		document
	end

end
