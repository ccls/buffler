class HomePagePic < ActiveRecord::Base
	validates_presence_of :title
	validates_length_of :title, :minimum => 4

	has_attached_file_options = { :styles => {
		:full   => "900",
		:large  => "800",
		:medium => "600",
		:small  => "150x50>"
	} }

	s3_options = {
		:s3_permissions => :public_read,	#	:private
		:storage => :s3,
		:s3_protocol => 'https',
		:s3_credentials => "#{Rails.root}/config/s3.yml",
		:bucket => RAILS_APP_NAME,	#'ucb_ccls_buffler',
		:path => 'home_page_pics/:attachment/:id/:style/:filename'
		#	S3 must have a defined path or will generate
		#	"Stack level too deep" errors
	}

	if Rails.env == 'production'
		has_attached_file_options.merge!(s3_options)
	else
		url = "/#{Rails.env}/system/:attachment/:id/:style/:filename"
		has_attached_file_options.merge!({
			:path => ":rails_root/public/#{url}",
			:url  => url
		})
	end

	has_attached_file :image, has_attached_file_options


#	class MissingAdapter < StandardError; end

	def self.random_active
#		#	there should be a better way.  a rails way.
#		#	This will cause code to be untested.
#		random = case adapter()
#			when "mysql"   then "RAND()"
#			when "sqlite3" then "Random()"
#			else raise MissingAdapter
#		end
#		first( :order => random, :conditions => { :active => true } )
		conditions = [ 'active = ? AND image_file_name IS NOT NULL', true ]
		c = HomePagePic.count(:conditions => conditions )
		if c > 0
			first(:offset => rand(c), :conditions => conditions )
		else
			nil
		end
	end

protected

#	def self.adapter
#		could've used connection.adapter_name 
#		(but be careful as the CaSE isn't always the same for all rubies)
#		@adapter ||= connection.instance_variable_get(:@config)[:adapter]
#	end

end
