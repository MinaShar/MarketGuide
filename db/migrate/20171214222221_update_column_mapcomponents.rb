class UpdateColumnMapcomponents < ActiveRecord::Migration[5.0]
  def up
    change_column :mapcomponents, :is_vertical, :integer
  end

end
