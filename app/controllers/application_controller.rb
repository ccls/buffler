require 'ssl_requirement'
class ApplicationController < ActionController::Base
	include SslRequirement

	helper :all # include all helpers, all the time

	# See ActionController::RequestForgeryProtection for details
	protect_from_forgery 

	before_filter :login_required

	base_server_url = ( RAILS_ENV == "production" ) ? 
		"https://auth.berkeley.edu" : 
		"https://auth-test.berkeley.edu"

	CASClient::Frameworks::Rails::Filter.configure(
		:username_session_key => :calnetuid,
		:cas_base_url => "#{base_server_url}/cas/"
	)

	helper_method :current_user, :logged_in?

protected	#	private #	(does it matter which or if neither?)

	#	used in roles_controller
	def may_not_be_user_required
		current_user.may_not_be_user?(@user) || access_denied(
			"You may not be this user to do this", user_path(current_user))
	end

	def logged_in?
		!current_user.nil?
	end

	#	Force the user to be have an SSO session open.
	def current_user_required
		# Have to add ".filter(self)" when not in before_filter line.
		CASClient::Frameworks::Rails::Filter.filter(self)
	end
	alias_method :login_required, :current_user_required

	def current_user
#		load 'user.rb' unless defined?(User)
		@current_user ||= if( session && session[:calnetuid] )
				#	if the user model hasn't been loaded yet
				#	this will return nil and fail.
				User.find_create_and_update_by_uid(session[:calnetuid])
			else
				nil
			end
	end

	def auth_redirections(permission_name)
		if respond_to?(:redirections) && 
			redirections.is_a?(Hash) &&
			!redirections[permission_name].blank?
			redirections[permission_name]
		else
			HashWithIndifferentAccess.new
		end
	end

	def method_missing_with_authorization(symb,*args, &block)
		method_name = symb.to_s

		if method_name =~ /^may_(not_)?(.+)_required$/
			full_permission_name = "#{$1}#{$2}"
			negate = !!$1		#	double bang converts to boolean
			permission_name = $2
			verb,target = permission_name.split(/_/,2)

			#	using target words where singular == plural won't work here
			if !target.blank? && target == target.singularize
				unless permission = current_user.try(
						"may_#{permission_name}?", 
						instance_variable_get("@#{target}") 
					)
					message = "You don't have permission to " <<
						"#{verb} this #{target}."
				end
			else
				#	current_user may be nil so must use try and NOT send
				unless permission = current_user.try("may_#{permission_name}?")
					message = "You don't have permission to " <<
						"#{permission_name.gsub(/_/,' ')}."
				end
			end

			#	exclusive or
			unless negate ^ permission
				#	if message is nil, negate will be true
				message ||= "Access denied.  May #{(negate)?'not ':''}" <<
					"#{permission_name.gsub(/_/,' ')}."
				ar = auth_redirections(full_permission_name)
				access_denied(
					(ar[:message]||message),
					(ar[:redirect_to]||root_path||"/")
				)
			end
		else
			method_missing_without_authorization(symb, *args, &block)
		end
	end
	alias_method_chain :method_missing, :authorization

	def ssl_required?
		# Force https everywhere (that doesn't have ssl_allowed set)
		true
	end

	def redirect_to_referer_or_default(default)
		redirect_to( session[:refer_to] || 
			request.env["HTTP_REFERER"] || default )
		session[:refer_to] = nil
	end

	#	Flash error message and redirect
	def access_denied( 
			message="You don't have permission to complete that action.", 
			default=root_path )
		session[:return_to] = request.request_uri unless params[:format] == 'js'
		flash[:error] = message
		redirect_to default
	end

end
__END__
