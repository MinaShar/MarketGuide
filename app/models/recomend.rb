class Recomend < ApplicationRecord

	def self.get_user_product_table
		result=ActiveRecord::Base.connection.exec_query("select DISTINCT products.id AS 'product_id',users.id AS 'user_id'
														FROM products
														INNER JOIN shoppinglistsitem ON products.id=shoppinglistsitem.product_id
														INNER JOIN shoppinglists ON shoppinglistsitem.shoppinglist_id=shoppinglists.id
														INNER JOIN users ON users.id=shoppinglists.user_id
														ORDER BY products.id ASC")
		return result
	end

	def self.check_user_bought_product(user_id,product_id,table)

		table.each_with_index do |row,index|
			if row['product_id'].to_i == product_id.to_i && row['user_id'].to_i == user_id.to_i
				return 1
			end
		end

		return 0
	end

	def self.get_index_min_in_similarity(similarityTable)
		
		index_min_similarity = -1 
		min_similarity = similarityTable[0]["similarity"].to_i
		similarityTable.each_with_index do |element,index|
			if(element["similarity"] < min_similarity)
				index_min_similarity = index
			end
		end

		return index_min_similarity

	end
end
