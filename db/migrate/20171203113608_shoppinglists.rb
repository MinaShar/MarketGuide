class Shoppinglists < ActiveRecord::Migration[5.0]
  def change
  	create_table :shoppinglists do |t|
			t.references :user , foreign_key: {on_delete: :cascade}
			t.references :chain , foreign_key: {on_delete: :cascade}
			t.references :branch , foreign_key: {on_delete: :cascade}
			t.datetime :date
			t.string :name
			t.timestamps
	end
  end
end
