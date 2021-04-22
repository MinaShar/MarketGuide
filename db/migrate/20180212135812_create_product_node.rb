class CreateProductNode < ActiveRecord::Migration[5.0]
  def change
    create_table :product_nodes do |t|
    	t.references :product , foreign_key: {on_delete: :cascade}
    	t.references :mapnode , foreign_key: {on_delete: :cascade}
    	t.timestamps
    end
  end
end
