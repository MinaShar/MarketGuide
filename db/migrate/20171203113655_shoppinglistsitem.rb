class Shoppinglistsitem < ActiveRecord::Migration[5.0]
  def change
  	create_table :shoppinglistsitem do |t|
			t.references :shoppinglist , foreign_key: {on_delete: :cascade}
			t.references :product , foreign_key: {on_delete: :cascade}
			t.timestamps
	end
  end
end
