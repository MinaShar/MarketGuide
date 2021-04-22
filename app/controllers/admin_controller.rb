class AdminController < ApplicationController

	skip_before_filter :verify_authenticity_token

	$vertical_width = 9
	$vertical_height = 97

	$horizontal_width = 97
	$horizontal_height = 9

	def test_function
		# puts "here is the results => "
		# puts Tsp.find_minimum_from_to(403,420)
		a = [1,2,3,4]
		arrays = a.permutation(a.length)
		arrays.each do |e|
			puts e.inspect
		end 
		# puts "id of the entrance point = "
		# puts Mapnode.get_id_entrance_point()
		# Productnode.map_products_to_nodes()
		# my_line=Line.new(Point.new(5,5),Point.new(5,10))
		# result = my_line.is_intersecting({ "X" => 13 , "Y" => 2 , "is_vertical" => 0 })
		# puts "so the result of the equation we got ===> #{result}"
		render :nothing => true, :status => 200, :content_type => 'text/html'
	end

	def index
		
	end

	def getMapPage
		Productlocation.delete_all()
	end

	def create_map
		# puts 'HERE IS THE PARAMETERS WE GOT'
		# puts params
		Nodenodeweight.delete_all()
		Productnode.delete_all()
		Mapcomponent.delete_every_thing()
		Mapnode.delete_all()
		Mapregion.delete_every_thing()
		map = params[:map]
		regions = params[:regions]
		map.each do |key,value|
			# puts "KEY = #{key} >><< VALUE of X = #{value[:X]}"
			Mapcomponent.add_new(value[:X],value[:Y],value[:is_vertical])
		end

		regions.each do |key,value|
			Mapregion.add_new(value[:x],value[:y],value[:width],value[:height],value[:r],value[:g],value[:b],value[:name])
		end

		Mapnode.entrance_point(0,0)

		# create map nodes
		map.each do |key,value|
			puts value
			Mapnode.form_nodes(value[:X],value[:Y],value[:is_vertical])		
		end
		# end create map nodes

		Nodenodeweight.calculate_node_node_weights()

		Productnode.map_products_to_nodes()

		response={'code' => 1}
        render :json => response 
	end

	def get_all_products
		result=Product.get_all()
		response = { 'products' => result }
		render :json => response 
	end

	def add_product_location
		puts "this is the parameters arrived"
		puts params
		inserted_record = Productlocation.add_new(params[:product_id],params[:x],params[:y])
		result = { 'data' => inserted_record }
		render :json => result
	end

	def get_product_by_product_location_id
		name2=Product.get_product_by_product_location_id(params[:product_location_id])
		result = {'name' => name2}
		render :json => result
	end

	def get_map_nodes
		result=Mapnode.get_map_nodes()
		data = { 'nodes' => result }
		render :json => data
	end
end
