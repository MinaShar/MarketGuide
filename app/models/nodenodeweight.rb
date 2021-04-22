class Nodenodeweight < ApplicationRecord

	def self.calculate_node_node_weights()
		
		all_map_components = Mapcomponent.get_all()
		all_map_nodes = Mapnode.get_map_nodes()

		all_map_nodes.each do |key1|
			
			all_map_nodes.each do |key2|
				distance = Line.deistance_between(Point.new(key1['X'],key1['Y']),Point.new(key2['X'],key2['Y']))
				
				node_node_line=Line.new(Point.new(key1['X'],key1['Y']),Point.new(key2['X'],key2['Y']))

				flag_continue = false
				all_map_components.each do|single_component|
					result = node_node_line.is_intersecting(single_component)
					if result == true
						ActiveRecord::Base.connection.exec_query("insert into nodenodeweights (`node1_id_id`,`node2_id_id`,`distance`,`created_at`,`updated_at`) values (#{key1['id']},#{key2['id']},#{-1},NOW(),NOW())")
						flag_continue = true
						break
					end
				end

				if flag_continue == false
					ActiveRecord::Base.connection.exec_query("insert into nodenodeweights (`node1_id_id`,`node2_id_id`,`distance`,`created_at`,`updated_at`) values (#{key1['id']},#{key2['id']},#{distance},NOW(),NOW())")
				end

			end

		end

	end

	def self.delete_all
		ActiveRecord::Base.connection.exec_query("DELETE FROM `nodenodeweights` ")
	end

	def self.get_all
		ActiveRecord::Base.connection.exec_query("SELECT * FROM `nodenodeweights` ")
	end
end
