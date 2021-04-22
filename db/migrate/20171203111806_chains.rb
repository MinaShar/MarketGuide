class Chains < ActiveRecord::Migration[5.0]
  def change
  	create_table :chains do |t|
		t.string :name
		t.timestamps
	end
  end
end
