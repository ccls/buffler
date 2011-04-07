namespace :app do

	desc "Load some fixtures to database for application"
	task :setup => :environment do
		fixtures = []
#		fixtures.push('pages')
		fixtures.push('roles')
		ENV['FIXTURES'] = fixtures.join(',')
		puts "Loading fixtures for #{ENV['FIXTURES']}"
		Rake::Task["db:fixtures:load"].invoke

#
#	was going to use ccls engines namespace,
#	by buffler no longer uses ccls_engine
#
#		Rake::Task["ccls:add_users"].invoke
#		ENV['uid'] = '859908'
#		Rake::Task["ccls:deputize"].invoke
#		ENV['uid'] = '228181'
#		Rake::Task["ccls:deputize"].reenable	#	<- this is stupid!
#		Rake::Task["ccls:deputize"].invoke

#mountain_stream.jpg

		%w( mountain_stream.jpg ).each do |hpp|
			HomePagePic.create(:title => hpp,
				:image => File.open(File.join(RAILS_ROOT,'to_upload',hpp)))
		end
	end

end
