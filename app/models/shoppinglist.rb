class Shoppinglist < ApplicationRecord

	def self.previous_shopping_lists(user_id)
		result=ActiveRecord::Base.connection.exec_query("select `shoppinglists`.*,`chains`.`name` as `chain_name`,`branches`.`name` as `branch_name`
			from `shoppinglists` 
			INNER JOIN `chains` ON `chains`.`id`=`shoppinglists`.`chain_id` 
			INNER JOIN `branches` ON `branches`.`id`=`shoppinglists`.`branch_id` 
			WHERE `shoppinglists`.`user_id`=#{user_id} 
			ORDER BY `shoppinglists`.`created_at` DESC ")
		return result
	end

	def self.get_list(list_id)
		result = ActiveRecord::Base.connection.exec_query("SELECT `shoppinglists`.*,`chains`.`name` AS 'chain_name',`branches`.`name` AS 'branch_name' 
			FROM `shoppinglists` INNER JOIN `chains` ON `shoppinglists`.`chain_id`=`chains`.`id` 
			INNER JOIN `branches` ON `branches`.`id`=`shoppinglists`.`branch_id` 
			WHERE `shoppinglists`.`id`=#{list_id} ")
		return result[0]
	end

	def self.create_new(user_id,chain_id,branch_id,name)
		ActiveRecord::Base.connection.exec_query("
			INSERT INTO `shoppinglists` (`user_id`,`chain_id`,`branch_id`,`date`,`name`,`created_at`,`updated_at`) 
			VALUES ( #{user_id} ,#{chain_id} , #{branch_id} , NOW() ,'#{name}', NOW() , NOW() ) 
			")

		result=ActiveRecord::Base.connection.exec_query("SELECT LAST_INSERT_ID() AS id;")
		return result[0]['id']
	end


	def self.get_products_of_shopping_list(list_id)
		result=ActiveRecord::Base.connection.exec_query("select `product_id` from shoppinglistsitem where `shoppinglist_id`=#{list_id}")
		products = []
		result.each do |row|
			products.push(row['product_id'])
		end
		return products
	end
end
