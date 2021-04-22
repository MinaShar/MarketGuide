class Shoppinglistitem < ApplicationRecord

	def self.add_list_item(shoppinglist_id,product_id)
		ActiveRecord::Base.connection.exec_query("insert into shoppinglistsitem ( `shoppinglist_id`, `product_id`, `created_at`, `updated_at` ) values ( #{shoppinglist_id} ,#{product_id},  NOW() ,  NOW()  )")
	end
end
