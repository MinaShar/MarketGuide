class Mapnodes < ActiveRecord::Migration[5.0]
  def change
    create_table :mapnodes do |t|
    	t.float :X
  		t.float :Y
      	t.timestamps
    end
  end
end
