Factory.define :home_page_pic do |f|
	f.sequence(:title){ |n| "Title #{n}" }
#	f.image File.open("#{Rails.root}/to_upload/mountain_stream.jpg")
end
Factory.define :photo do |f|
	f.sequence(:title) { |n| "Title#{n}" }
end
