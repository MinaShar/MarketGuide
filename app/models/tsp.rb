class Tsp < ApplicationRecord


	def self.get_path3(nodes_required)

		if nodes_required.count == 1
			return []
		end

		all_cases = []
		path = []
		all_nodes = []

		all_map_nodes = Mapnode.get_map_nodes()

		puts "At begining => all nodes required are :"
		puts nodes_required.inspect

		current_node = nodes_required[0]
		nodes_required.delete_at(0)

		while nodes_required.length > 1
			
			all_map_nodes_index = -1
			all_map_nodes.each_with_index do |element,index_required|
				if element['id'].to_i == current_node.to_i
					all_map_nodes_index = index_required
				end
			end

			location_current_node = all_map_nodes[all_map_nodes_index]

			# location_current_node=Mapnode.get_node_location(current_node)

			nodes_required.each_with_index do |element,i|
				node_location = self.get_node_location(all_map_nodes,element)
				required_distnce=Line.deistance_between(Point.new(location_current_node['X'],location_current_node['Y']),Point.new(node_location['X'],node_location['Y']))
				all_cases.push({'node'=>element,'distance'=>required_distnce})
			end

			required_node=self.get_node_minimum_distance(all_cases)

			puts "NOW WE ARE SOLVING GOING FROM NODE #{current_node} TO #{required_node}"

			objec=self.find_minimum_from_to(current_node,required_node)

			puts "to go from #{current_node} to #{required_node} you should go throw :"
			puts objec.inspect
			
			objec["nodes"].each do |elem|
				all_nodes.push(elem)
			end

			if current_node == required_node
				current_node = nodes_required[0]
			else
				current_node = required_node
			end

			nodes_required.delete(current_node)
			puts "now the current node is : #{current_node}"
			puts "now after reaching a node the rest are :"
			puts nodes_required.inspect

		end

		puts "NOW LOOP BREAKED UP"

		objec=self.find_minimum_from_to(current_node,nodes_required[0])
		objec["nodes"].each do |elem|
			all_nodes.push(elem)
		end

		puts "<<<<<<<<<<<NOW THE NODES ARE>>>>>>>>>>"
		puts all_nodes.inspect

		all_points = []
		all_nodes.each do |node|
			location=Mapnode.get_node_location(node)
			all_points.push(Point.new(location['X'],location['Y']))
		end
		puts "<<<<<<<<<<<<all points are>>>>>>>>>>"
		puts all_points.inspect

		return all_points

	end

	def self.get_node_location(all_map_nodes,required_node)
		all_map_nodes.each do |element|
			if element['id'].to_i == required_node
				return element
			end
		end
	end

	def self.get_node_minimum_distance(all_cases)
		min_distance = 10000
		required_node = -1
		all_cases.each do |element|
			if element['distance'] < min_distance
				min_distance = element['distance']
				required_node = element['node']
			end
		end
		return required_node
	end

	# get path with respect to thier order only >>> no more processing
	def self.get_path2(nodes_required)
		
		puts "the nodes in the arguments"
		puts nodes_required.inspect

		all_nodes = []
		total_cost_of_this_path = 0
		nodes_required.each_with_index do |node,i|
			if i == nodes_required.count - 1
				break
			end
			objec=self.find_minimum_from_to(nodes_required[i],nodes_required[i+1])
			puts "now to reach from #{nodes_required[i]} to #{nodes_required[i+1]}"
			puts objec["nodes"].inspect
			objec["nodes"].each do |elem|
				all_nodes.push(elem)
			end

			total_cost_of_this_path += objec["cost"].to_f
		end

		puts "<<<<<<<<<here are the resulting nodes>>>>>>>>>>"
		puts all_nodes.inspect

		all_points = []
		all_nodes.each do |node|
			location=Mapnode.get_node_location(node)
			all_points.push(Point.new(location['X'],location['Y']))
		end

		return all_points

	end

	# choose all possible compinations (its working nice only in small nodes)
	def self.get_path(nodes_required)

		nodes_required_except_entrance = []

		nodes_required.each_with_index do |node,i|
			if i==0
				next
			else
				nodes_required_except_entrance.push(node)	
			end
		end

		mycontainer = []

		a = [1,2,3,4]
		arrays = nodes_required_except_entrance.permutation(nodes_required_except_entrance.length)
		puts "now we have compinations = #{arrays.count}"
		index_for_debugging = 0
		arrays.each do |e|
			puts "in compination number #{ index_for_debugging }"
			index_for_debugging+=1
			one_permutation = [nodes_required[0]]
			e.each do |s_p|
				one_permutation.push(s_p)
			end
			all_nodes = []

			total_cost_of_this_path = 0

			one_permutation.each_with_index do |node,i|
				if i == one_permutation.count - 2
					break
				end
				objec=self.find_minimum_from_to(one_permutation[i],one_permutation[i+1])
				objec["nodes"].each do |elem|
					all_nodes.push(elem)
				end

				total_cost_of_this_path += objec["cost"].to_f
			end

			mycontainer.push({"nodes"=>all_nodes,"cost"=>total_cost_of_this_path})

		end

		index_min_path = 0
		min_cost = 10000
		mycontainer.each_with_index do |elem,i|
			if elem["cost"] < min_cost
				min_cost = elem["cost"]
				index_min_path = i
			end
		end

		all_points = []
		all_nodes = mycontainer[index_min_path]["nodes"]
		all_nodes.each do |node|
			location=Mapnode.get_node_location(node)
			all_points.push(Point.new(location['X'],location['Y']))
		end

		return all_points
	end

	def self.find_minimum_from_to(node1_id,node2_id)

		all_possible_passes = []
		all_node_node_weights = Nodenodeweight.get_all()

		node_reached = node1_id

		if node1_id.to_i == node2_id.to_i
			return {"cost"=>0,"nodes"=>[node1_id.to_i]}
		end

		all_node_node_weights.each do |row|
			if row['node1_id_id'].to_i == node_reached.to_i
				if row['distance'].to_f <= 0.0
					next
				end
				all_possible_passes.push({"cost"=>row['distance'].to_f,"nodes"=>[node_reached.to_i,row['node2_id_id'].to_i]})
			end
		end

		while true

			all_possible_passes.each_with_index do |row,i|
		 		# puts "<<<<<new array>>>>"
		 		# puts row['nodes'].inspect
		 		
		 		result = self.is_destination_reached(all_possible_passes,node2_id)
		 		if result >= 0
		 			# puts ">>>>>>>>>>>>here is the final array<<<<<<<<<<<<<<"
		 			return all_possible_passes[result]
		 		end 

		 		current_object = row
		 		all_possible_passes.delete_at(i)

		 		# puts "here is the paths after being deleted"
		 		# puts all_possible_passes.inspect
		 		# puts ">>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<"

		 		nodes=current_object["nodes"]

		 		all_node_node_weights.each do |element|

		 			if self.check_node_exist(element['node2_id_id'].to_i,nodes) == true
		 				next
		 			end

		 			arr2 = []
		 			nodes.each do |e|
		 				arr2 << e
		 			end
		 			
		 			if element['node1_id_id'].to_i == nodes.last.to_i
		 				if element['distance'].to_f <= 0
		 					next
		 				end
		 				all_possible_passes.push({"cost"=>current_object["cost"].to_f + element['distance'].to_f,"nodes"=>arr2.push(element['node2_id_id'].to_i)})
		 				# puts "now the last hash added is:"
		 				# puts all_possible_passes.last.inspect
		 			end
		 		end

		 		# self.print_passes(all_possible_passes)

		 		# if all_possible_passes.count > 20
		 		# 	puts "count excceeds 20"
		 		# 	return 
		 		# end

		 		break

		 	end

		 end

	 	# puts "here is the arry after deleting @ 2"
	 	# all_possible_passes.delete_at(2)
	 	# all_possible_passes.each_with_index do |row,i|
	 	# 	puts "#{i} => #{row}"
	 	# end
	 end

	 def self.print_passes(passes)
	 	puts "///////////////////Now the pathes we have//////////////////////"
	 	passes.each do |path|
	 		puts path["nodes"].inspect
	 	end
	 	puts "///////////////////////////////////////////////////////////////"
	 end

	 def self.check_node_exist(node,nodes)
	 	nodes.each do |n|
	 		if node.to_i == n
	 			return true
	 		end
	 	end
	 	return false
	 end

	 def self.is_destination_reached(paths,destination)

	 	paths.each_with_index do |path,i|
	 		if path['nodes'].last.to_i == destination.to_i and self.is_cost_minimum(i,paths)
	 			return i
	 		end
	 	end

	 	return -1
	 end

	 def self.is_cost_minimum(index,paths)

	 	required_cost = paths[index]["cost"].to_i

	 	paths.each_with_index do |path,i|
	 		if index == i
	 			next
	 		else if path['cost'].to_i < required_cost 
	 			return false
	 		end
	 	end

	 	return true

	 end
	end
end
