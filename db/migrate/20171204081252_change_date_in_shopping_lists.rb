class ChangeDateInShoppingLists < ActiveRecord::Migration[5.0]
  def up
    change_column :shoppinglists, :date, :date
  end

  def down
    change_column :shoppinglists, :date, :datetime
  end

end
