class Users < ActiveRecord::Migration[5.0]
  def change
  	create_table :users do |t|
  		t.string :user_name
  		t.string :user_gender
  		t.string :user_email
  		t.string :user_password
  		t.string :user_dop
  		t.string :user_phone
  		t.timestamps
  	end
  end
end
