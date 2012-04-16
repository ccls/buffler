Factory.define :home_page_pic do |f|
	f.sequence(:title){ |n| "Title #{n}" }
#	f.image File.open("#{Rails.root}/to_upload/mountain_stream.jpg")
end
Factory.define :photo do |f|
	f.sequence(:title) { |n| "Title#{n}" }
end
Factory.define :page do |f|
	f.sequence(:path) { |n| "/path#{n}" }
	f.sequence(:menu_en) { |n| "Menu #{n}" }
	f.sequence(:title_en){ |n| "Title #{n}" }
	f.body_en  "Page Body"
end

Factory.define :user do |f|
	f.sequence(:uid) { |n| "UID#{n}" }
#	f.sequence(:username) { |n| "username#{n}" }
#	f.sequence(:email) { |n| "username#{n}@example.com" }
#	f.password 'V@1!dP@55w0rd'
#	f.password_confirmation 'V@1!dP@55w0rd'
#	f.role_name 'user'
end
Factory.define :role do |f|
	f.sequence(:name) { |n| "name#{n}" }
end

