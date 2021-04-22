class AddNameToMapregions < ActiveRecord::Migration[5.0]
  def change
    add_column :mapregions, :name, :string
  end
end
