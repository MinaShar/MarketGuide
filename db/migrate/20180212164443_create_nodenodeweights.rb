class CreateNodenodeweights < ActiveRecord::Migration[5.0]
	def change
		create_table :nodenodeweights do |t|
			t.references :node1_id , foreign_key:  { to_table: :mapnodes }
			t.references :node2_id , foreign_key:  { to_table: :mapnodes }
			t.float :distance
			t.timestamps
		end
	end
end
