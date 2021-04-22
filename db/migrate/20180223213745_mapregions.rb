class Mapregions < ActiveRecord::Migration[5.0]
  def change
  	create_table :mapregions do |t|
		t.float :x
		t.float :y
		t.float :width
		t.float :height
		t.float :r
		t.float :g
		t.float :b
		t.timestamps
	end
  end
end
