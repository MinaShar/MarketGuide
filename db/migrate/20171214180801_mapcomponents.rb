class Mapcomponents < ActiveRecord::Migration[5.0]
  def change
  	create_table :mapcomponents do |t|
  		t.float :X
  		t.float :Y
  		t.binary :is_vertical
		t.timestamps
	end
  end
end
