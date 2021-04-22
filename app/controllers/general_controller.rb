class GeneralController < ApplicationController

	skip_before_filter :verify_authenticity_token

	require "uri"
	require "net/http"
	require 'json'
	require 'socket'

	def get_this_products
		products_names = []
		# puts "THIS IS THE PARAMETERS WE GOT"
		# puts params
		products = params[:product_id]
		products.each do |p|
			products_names.push(Product.get_name(p))
		end
		response = {'names' => products_names}
		render :json => response
	end

	def index
		result = User.getAll()
		render :json => result   
	end

	def register
		result = User.register(params[:name],params[:date],params[:gender],params[:email],params[:password],params[:phone])

		if(result != nil)
			response = { 'code' => 1 , 'message' => "authenticated", 'user' => result }
		else
			response = { 'code' => -1 , 'message' =>  "whether email or password is wrong!" }
		end
		render :json => response   
	end

	def login
		result = User.login(params[:email],params[:password])
		if(result != nil)
			response = { 'code' => 1 , 'message' => "authenticated", 'user' => result }
		else
			response = { 'code' => -1 , 'message' =>  "whether email or password is wrong!" }
		end
		render :json => response   

	end

	def test
		response = "connected !"
		render :json => response  
	end

	def GetUserData
		result = User.GetUserData(params[:user_id])
		response={'user' => result}
		render :json => response 
	end

	def previous_shopping_lists
		result=Shoppinglist.previous_shopping_lists(params[:user_id])
		response={'lists' => result}
		render :json => response 
	end

	def search_products
		result=Product.search_products(params[:product])
		response={'products' => result}
		render :json => response 
	end

	def products_of_shopping_list
		result=Product.products_of_shopping_list(params[:shoppinglist_id])
		response={'products' => result}
		render :json => response 
	end

	def old_shopping_list
		list=Shoppinglist.get_list(params[:old_list_id])
		products=Product.get_products_of_shopping_list(params[:old_list_id])
		response = { 'list' => list , 'products' => products }
		render :json => response 
	end

	def get_all_chains
		all_chains=Chain.get_all
		response = { 'chains' => all_chains }
		render :json => response 
	end

	def get_branches_of_chain
		result=Branch.get_branches_of_chain(params[:chain_id])
		response = { 'branches' => result }
		render :json => response 
	end

	def add_new_list
		puts "Now inside Add New List function with this parameters"
		# puts params
		# params[:product].each do |value|
		# 	puts "value => #{value}"
		# end

		new_list_id=Shoppinglist.create_new(params[:user_id],params[:chain_id],params[:branch_id],params[:name])

		params[:product].each do |value|
			Shoppinglistitem.add_list_item(new_list_id,value)
		end

		response = { 'code' => 1 }
		render :json => response 

	end

	def check_email_exist
		result=User.check_email_exist(params[:email])
		response = { 'code' => result }
		render :json => response 
	end

	def get_map
		result=Mapcomponent.get_all()
		regions=Mapregion.get_all()
		response = { 'map' => result , 'regions' => regions }
		render :json => response 
	end

	def test2
		# p = Point.new(5,5)
		# arr = p.branch_on_point()
		# render :json => arr 
		# pointsonroute = []
		# products_required = [17,18,20]
		# startlocation = Point.new(0,0)

		# products_required.each do |e|
		# 	puts "now the value = #{e}"
		# 	location=Productlocation.get_product_location(e)
		# 	# pointsonroute.push( { 'product'=> e , 'X'=> location[0]['X'] , 'Y' =>location[0]['Y'] } )
		# 	pointsonroute.push( Pointonroute.new( Point.new(location[0]['X'],location[0]['Y']) , false ) )
		# end

		# next_desti=Line.decide_next_destination(startlocation,pointsonroute)

		# map_components=Mapcomponent.get_all
		# map_components=Rectangle.create_rects_from_map_components(map_components)
		# rects = []
		# rects.push(Rectangle.new(13,13,100,100))
		# result=Rectangle.check_point_availability(Point.new(5,5),rects)
		path = []
		map_components=Mapcomponent.get_all
		map_components=Rectangle.create_rects_from_map_components(map_components)
		Point.reach_from_to(Point.new(0,0),Point.new(300,200),path,map_components)
		render :json => path 
	end

	# TRAVELLING SALES MAN ALGO.
	def get_path2
		list_required = params[:list_id]
		products_required = Shoppinglist.get_products_of_shopping_list(list_required)

		nodes_required = []
		products_not_found = []
		locations = []

		
		nodes_required.push( Mapnode.get_id_entrance_point() )
		products_required.each do |product_id|
			result = Productnode.get_node_of_product(product_id)
			if result != -1
				nodes_required.push( result )

				location=Productlocation.get_product_location(product_id)
				product_name = Product.get_name(product_id)
				locations.push("point" => Point.new(location[0]['X'],location[0]['Y']) , "name" => product_name )
			else
				products_not_found.push(product_id)
			end
			
		end

		points=Tsp.get_path3(nodes_required)
		result = { 'path' => points , 'products_not_found' =>products_not_found , 'locations'=>locations }

		render :json => result 
	end

	def get_area_data
		pointX = params[:pointX]
		pointY = params[:pointY]

		targets = []

		product_locations=Productlocation.get_products_around(pointX.to_f,pointY.to_f)
		puts product_locations.inspect
		product_locations.each do |elem|
			product_name = Product.get_name(elem["product_id"])
			targets.push({"point"=>Point.new(elem["X"],elem["Y"]),"name"=>product_name})
		end
		render :json => targets 
	end

	# OLD ALGORITHM
	def get_path

		list_required = params[:list_id]
		products_not_found = []
		path = []
		pointsonroute = []
		products_required = Shoppinglist.get_products_of_shopping_list(list_required)
		startlocation = Point.new(0,0)

		products_required.each do |e|
			puts "now the value = #{e}"
			location=Productlocation.get_product_location(e)
			if location != nil
			# pointsonroute.push( { 'product'=> e , 'X'=> location[0]['X'] , 'Y' =>location[0]['Y'] } )
			pointsonroute.push( Pointonroute.new( Point.new(location[0]['X'],location[0]['Y']) , false ) )

			else
				products_not_found.push(e)
			end
		end

		# puts pointsonroute

		map_components=Mapcomponent.get_all
		map_components=Rectangle.create_rects_from_map_components(map_components)

		# Pointonroute.is_all_reached(pointsonroute)

		# i = 0
		# while i < 3
		# 	puts "X = #{pointsonroute[i].point.x} & Y = #{pointsonroute[i].point.y}"
		# 	i+=1
		# end

		last_position_reached = startlocation
		while true
			if Pointonroute.is_all_reached(pointsonroute) == true
				break
			end
			# must be removed >> for testing only
			if path.count > 4000
				puts 'points reached the limit permitted'
				break
			end
			##################
			next_desti=Line.decide_next_destination(last_position_reached,pointsonroute)
			Point.reach_from_to(last_position_reached,next_desti.point,path,map_components)
			next_desti.is_reached = true
			last_position_reached = path[path.count-1]
		end

		# result=Productlocation.get_product_location(17)
		# result = { 'product' => result }
		# rect = Rectangle.new(4,4,20,20)
		# result=rect.is_containing(Point.new(5,5))
		# result=Line.deistance_between(Point.new(5,5),Point.new(10,10))
		result = { 'path' => path , 'products_not_found' =>products_not_found }

		render :json => result 
	end

end
