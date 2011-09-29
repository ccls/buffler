# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.14' unless defined? RAILS_GEM_VERSION

#ENV['RAILS_ENV'] ||= 'production'

#	In production, using script/console does not properly
#	set a GEM_PATH, so gems aren't loaded correctly.
if ENV['RAILS_ENV'] == 'production'
ENV['GEM_PATH'] = File.expand_path(File.join(File.dirname(__FILE__),'..','gems'))
end

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

#	This constant is used in the ucb_ccls_engine#Document
#	and other places like Amazon buckets
#	for controlling the path to documents.
RAILS_APP_NAME = 'buffler'

Rails::Initializer.run do |config|

	if RUBY_PLATFORM =~ /java/
		config.gem 'activerecord-jdbcsqlite3-adapter',
			:lib => 'active_record/connection_adapters/jdbcsqlite3_adapter'
		config.gem 'jdbc-sqlite3', :lib => 'jdbc/sqlite3'
		config.gem 'jruby-openssl', :lib => 'openssl'
	else
		config.gem "sqlite3"
	end

	#	due to some enhancements, the db gems MUST come first
	#	for use in the jruby environment.
	config.gem 'ccls-calnet_authenticated'

	#	Without this, rake doesn't properly include that app/ paths?
#	config.gem 'ccls-common_lib'

	config.gem 'jakewendt-simply_authorized'		#	TODO remove me
#	config.gem 'jakewendt-simply_pages'		#	TODO remove me
	config.gem 'jakewendt-simply_helpful'		#	TODO remove me
	config.gem 'jakewendt-ruby_extension'		#	TODO remove me
	config.gem 'jakewendt-rails_extension'		#	TODO remove me
	config.gem 'ssl_requirement'
	config.gem 'jrails'
#	config.gem 'gravatar'		#	TODO remove me
	config.gem 'ryanb-acts-as-list', :lib => 'acts_as_list'
	config.gem 'paperclip'
	config.gem 'ucb_ldap', '>= 1.4.2'
	config.gem 'rubycas-client', '>= 2.2.1'
	config.gem 'RedCloth', '> 4.2.6'

	#	require it, but don't load it
	config.gem 'jakewendt-rdoc_rails', :lib => false		#	TODO remove me

	#		http://chronic.rubyforge.org/
	config.gem "chronic"	#, :version => '= 0.5.0'
	config.gem 'will_paginate'
	config.gem 'fastercsv'
	config.gem "aws-s3", :lib => "aws/s3"

	# config.plugins = [ :exception_notification, :ssl_requirement, :all ]

	config.frameworks -= [ :active_resource ]

	# Set Time.zone default to the specified zone and make Active Record 
	#	auto-convert to this zone.
	# Run "rake -D time" for a list of tasks for finding time zone names.
	config.time_zone = 'UTC'

end

HTML::WhiteListSanitizer.allowed_tags.merge(%w(
	iframe
))

