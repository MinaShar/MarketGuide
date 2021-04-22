class Productlocation < ApplicationRecord

	def self.get_product_location(product_id)
		result=ActiveRecord::Base.connection.exec_query("select * from productlocations where product_id=#{product_id}")
		if result.count > 0
			return result
		else
			return nil
		end
	end


	def self.delete_all
		ActiveRecord::Base.connection.exec_query("delete from productlocations")
	end

	def self.add_new(product_id,x,y)
		ActiveRecord::Base.connection.exec_query("insert into productlocations (product_id,X,Y,created_at,updated_at)
			values (#{product_id},#{x},#{y},NOW(),NOW())")

		result=ActiveRecord::Base.connection.exec_query("SELECT LAST_INSERT_ID() AS id;")

		result= ActiveRecord::Base.connection.exec_query("SELECT * from productlocations where id=#{result[0]['id']}")
		return result[0]
	end

	def self.get_all()
		result = ActiveRecord::Base.connection.exec_query('select * from productlocations')
		return result
	end

	def self.get_products_around(x,y)

		min_x = x - 100.0
		max_x = x + 100.0

		min_y = y - 100.0
		max_y = y + 100.0

		result = ActiveRecord::Base.connection.exec_query("select * from `productlocations`")
		return result
	end
end
