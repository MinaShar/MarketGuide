class Productnode < ApplicationRecord

	def self.map_products_to_nodes()
		all_products_locations = Productlocation.get_all()
		all_map_nodes = Mapnode.get_map_nodes()

		all_products_locations.each do |value1|
			all_distances_to_nodes = []

			all_map_nodes.each do |value2|

				distance = Line.deistance_between(Point.new(value1['X'],value1['Y']),Point.new(value2['X'],value2['Y']))

				all_distances_to_nodes.push({ "node_id" => value2['id'] , "distance" => distance })
			end

			node_id = self.select_minimum_distance_node(all_distances_to_nodes)
			
			self.insert_into_table(value1['product_id'],node_id)
		end
	end

	def self.get_node_of_product(product_id)
		result=ActiveRecord::Base.connection.exec_query("select mapnode_id from product_nodes where product_id=#{product_id}")
		if result.count > 0
			return result[0]['mapnode_id']
		else
			return -1
		end
	end

	def self.insert_into_table(product_id,node_id)
		ActiveRecord::Base.connection.exec_query("insert into product_nodes(product_id,mapnode_id,created_at,updated_at) values (#{product_id},#{node_id},NOW(),NOW())")
	end

	def self.select_minimum_distance_node(all_distance_to_nodes)

		minimum_distance = 10000.0
		node_id = -1

		all_distance_to_nodes.each do |key|
			# puts " key => #{key}"
			if key["distance"] < minimum_distance
				minimum_distance = key["distance"]
				node_id = key["node_id"]				
			end
		end

		puts "node #{node_id} have distance #{minimum_distance}"

		return node_id

	end

	def self.delete_all
		ActiveRecord::Base.connection.exec_query("DELETE FROM `product_nodes` ")
	end
end
