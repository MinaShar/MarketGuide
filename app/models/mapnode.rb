class Mapnode < ApplicationRecord

	$vertical_width = 9
	$vertical_height = 97

	$horizontal_width = 97
	$horizontal_height = 9

	def self.form_nodes(x,y,is_vertical)
		
		x = x.to_f
		y = y.to_f
		is_vertical = is_vertical.to_i

		# horizontal
		if is_vertical==0
			ActiveRecord::Base.connection.exec_query("insert into mapnodes (`X`,`Y`,`created_at`,`updated_at`) values (#{ x - ( (30.0/100) * 1.0 * $horizontal_width ) },#{y},NOW(),NOW())")
			ActiveRecord::Base.connection.exec_query("insert into mapnodes (`X`,`Y`,`created_at`,`updated_at`) values (#{ ( x + 97.0 ) + ( (30.0/100) * 1.0 * $horizontal_width ) },#{y},NOW(),NOW())")
		
			ActiveRecord::Base.connection.exec_query("insert into mapnodes (`X`,`Y`,`created_at`,`updated_at`) values (#{ x },#{y - (25.0/100) * 1.0 * $horizontal_width },NOW(),NOW())")
			ActiveRecord::Base.connection.exec_query("insert into mapnodes (`X`,`Y`,`created_at`,`updated_at`) values (#{ x },#{y + (25.0/100) * 1.0 * $horizontal_width },NOW(),NOW())")

			ActiveRecord::Base.connection.exec_query("insert into mapnodes (`X`,`Y`,`created_at`,`updated_at`) values (#{ x + $horizontal_width },#{y - (25.0/100) * 1.0 * $horizontal_width },NOW(),NOW())")
			ActiveRecord::Base.connection.exec_query("insert into mapnodes (`X`,`Y`,`created_at`,`updated_at`) values (#{ x + $horizontal_width },#{y + (25.0/100) * 1.0 * $horizontal_width },NOW(),NOW())")
		else
			# vertical
			ActiveRecord::Base.connection.exec_query("insert into mapnodes (`X`,`Y`,`created_at`,`updated_at`) values (#{ x },#{ y - (30.0/100) * 1.0 * $vertical_height },NOW(),NOW())")
			ActiveRecord::Base.connection.exec_query("insert into mapnodes (`X`,`Y`,`created_at`,`updated_at`) values (#{ x },#{ y + $vertical_height + (30.0/100) * 1.0 * $vertical_height },NOW(),NOW())")
		
			ActiveRecord::Base.connection.exec_query("insert into mapnodes (`X`,`Y`,`created_at`,`updated_at`) values (#{ x - (25.0/100) * 1.0 * $vertical_height },#{ y },NOW(),NOW())")
			ActiveRecord::Base.connection.exec_query("insert into mapnodes (`X`,`Y`,`created_at`,`updated_at`) values (#{ x + (25.0/100) * 1.0 * $vertical_height },#{ y },NOW(),NOW())")

			ActiveRecord::Base.connection.exec_query("insert into mapnodes (`X`,`Y`,`created_at`,`updated_at`) values (#{ x - (25.0/100) * 1.0 * $vertical_height },#{y + $vertical_height },NOW(),NOW())")
			ActiveRecord::Base.connection.exec_query("insert into mapnodes (`X`,`Y`,`created_at`,`updated_at`) values (#{ x + (25.0/100) * 1.0 * $vertical_height },#{y + $vertical_height },NOW(),NOW())")	
		end
		
	end

	def self.entrance_point(x,y)
		ActiveRecord::Base.connection.exec_query("insert into mapnodes (`X`,`Y`,`created_at`,`updated_at`) values (#{x},#{y},NOW(),NOW())")
	end

	def self.get_id_entrance_point()
		result = ActiveRecord::Base.connection.exec_query("select MIN(id) from `mapnodes` ")
		if result.count > 0
			return result[0]["MIN(id)"]
		end
	end

	def self.delete_all
		ActiveRecord::Base.connection.exec_query("DELETE FROM `mapnodes` ")
	end

	def self.get_map_nodes
		result=ActiveRecord::Base.connection.exec_query("select * FROM `mapnodes` ")
		return result
	end

	def self.get_node_location(node_id)
		result=ActiveRecord::Base.connection.exec_query("select * from `mapnodes` where id=#{node_id}")
		return result[0]
	end
end
