class CreateHomePagePics < ActiveRecord::Migration
	def self.up
		table_name = 'home_page_pics'
		create_table table_name do |t|
			t.string  :title
			t.text    :caption
			t.boolean :active, :default => true
			t.timestamps
		end unless table_exists?(table_name)
		idxs = indexes(table_name).map(&:name)
		add_index( table_name, :active
			) unless idxs.include?("index_#{table_name}_on_active")
	end

	def self.down
		drop_table :home_page_pics
	end
end
