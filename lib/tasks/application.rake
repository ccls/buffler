namespace :app do

	desc "Load some fixtures to database for application"
	task :setup => :environment do
		fixtures = []
#		fixtures.push('pages')
		fixtures.push('roles')
		ENV['FIXTURES'] = fixtures.join(',')
		puts "Loading fixtures for #{ENV['FIXTURES']}"
		Rake::Task["db:fixtures:load"].invoke
		Rake::Task["app:add_users"].invoke
		ENV['uid'] = '859908'
		Rake::Task["app:deputize"].invoke
		ENV['uid'] = '228181'
		Rake::Task["app:deputize"].reenable	#	<- this is stupid!
		Rake::Task["app:deputize"].invoke

#mountain_stream.jpg

		%w( mountain_stream.jpg ).each do |hpp|
			HomePagePic.create(:title => hpp,
				:image => File.open(File.join(RAILS_ROOT,'to_upload',hpp)))
		end
	end

end
