Rails::Initializer.run do |config|

	# For CAS / CalNet Authentication
	config.gem "rubycas-client"

	# probably will come from http://gemcutter.org/gems/ucb_ldap
	# version 1.3.2 as of Jan 25, 2010
	config.gem "ucb_ldap", :source => "http://gemcutter.org"

	config.gem 'gravatar'

end
