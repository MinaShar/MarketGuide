class Branches < ActiveRecord::Migration[5.0]
  def change
  	create_table :branches do |t|
			t.references :chain , foreign_key: {on_delete: :cascade}
			t.string :name
			t.timestamps
	end
  end
end
