class ApplicationController < ActionController::Base

	before_filter :build_menu_js

	helper :all # include all helpers, all the time

	# See ActionController::RequestForgeryProtection for details
	protect_from_forgery 

protected	#	private #	(does it matter which or if neither?)

	#	This is a method that returns a hash containing
	#	permissions used in the before_filters as keys
	#	containing another hash with redirect_to and 
	#	message keys for special redirection.  By default,
	#	it will redirect to root_path on failure
	#	and the flash error will be a humanized
	#	version of the before_filter's name.
	def redirections
		@redirections ||= HashWithIndifferentAccess.new({
			:not_be_user => {
				:redirect_to => user_path(current_user)
			}
		})
	end


	#	The menu is on every page and this seems as the
	#	only way for me to force it into the application
	#	layout.
	def build_menu_js
		js = "" <<
			"if ( typeof(translatables) == 'undefined' ){\n" <<
			"	var translatables = [];\n" <<
			"}\n"
		Page.roots.each do |page|
			js << "" <<
				"tmp={tag:'#menu_#{dom_id(page)}',locales:{}};\n"
			%w( en es ).each do |locale|
				js << "tmp.locales['#{locale}']='#{page.menu(locale)}'\n"
			end
			js << "translatables.push(tmp);\n"
		end
		@template.content_for :head do
			@template.javascript_tag js
		end
	end

end
