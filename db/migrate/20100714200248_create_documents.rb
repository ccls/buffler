class CreateDocuments < ActiveRecord::Migration
	def self.up
		create_table :documents do |t|
			t.references :owner
			t.string :title
			t.text   :abstract
			t.timestamps
		end
		add_index :documents, :owner_id
	end

	def self.down
		drop_table :documents
	end
end