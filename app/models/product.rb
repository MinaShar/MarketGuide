class Product < ApplicationRecord
	
	def self.search_products(product)
		result=ActiveRecord::Base.connection.exec_query("select * from products where name like '#{product}%'")
		# if(result.count > 0)
		# 	return result[0]
		# else
		# 	return nil
		# end
		return result
	end

	def self.products_of_shopping_list(shopping_list_id)
		result=ActiveRecord::Base.connection.exec_query("SELECT products.*
				FROM products INNER JOIN shoppinglistsitem ON `products`.`id`=`shoppinglistsitem`.`product_id`
				INNER JOIN shoppinglists ON `shoppinglistsitem`.`shoppinglist_id`=`shoppinglists`.`id`
				WHERE `shoppinglists`.`id`=#{shopping_list_id}")
		return result
	end

	def self.get_products_of_shopping_list(list_id)
		result=ActiveRecord::Base.connection.exec_query("
			SELECT `products`.* FROM `products`
			INNER JOIN `shoppinglistsitem` ON `products`.`id`=`shoppinglistsitem`.`product_id`
			INNER JOIN `shoppinglists` ON `shoppinglists`.`id`=`shoppinglistsitem`.`shoppinglist_id`
			WHERE `shoppinglists`.`id`=#{list_id}
			")
		return result
	end

	def self.get_all
		result = ActiveRecord::Base.connection.exec_query("select * from products")
		return result
	end

	def self.get_name(product_id)
		result = ActiveRecord::Base.connection.exec_query("select `name` from products where id=#{product_id}")
		return result[0]['name']
	end

	def self.get_product_by_product_location_id(product_location_id)
		result = ActiveRecord::Base.connection.exec_query("
			SELECT `products`.`name` FROM `products`
			INNER JOIN `productlocations` ON `productlocations`.`product_id` = `products`.`id`
			WHERE `productlocations`.`id` = #{product_location_id}
			")

		return result[0]['name']
	end
end
