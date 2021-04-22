class UpdateColumnInUser < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :user_dop, :user_dob
  end
end
