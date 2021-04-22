class CreateProductlocations < ActiveRecord::Migration[5.0]
  def change
    create_table :productlocations do |t|
    	t.references :product , foreign_key: {on_delete: :cascade}
    	t.float :X
  		t.float :Y
      	t.timestamps
    end
  end
end
