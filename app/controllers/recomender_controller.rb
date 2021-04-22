class RecomenderController < ApplicationController

	def index
		user_id = params[:user_id]
		puts "we got user_id = #{user_id}"
		user_product_table = Recomend.get_user_product_table()
		all_users = User.getAll()
		all_products = Product.get_all()

		matrixTable = Array.new

		all_products.each_with_index do |single_product,product_index|

			product_id = single_product['id'].to_i

			users_bought_product_array = Array.new

			all_users.each_with_index do |element,index|
				user_id = element['id'].to_i
				users_bought_product_array.push Recomend.check_user_bought_product(user_id,product_id,user_product_table)
			end

			matrixTable << { "product_id" => product_id , "users" => users_bought_product_array }

		end

		################## NOW CHECK SIMILARITY #################
		similarityTable = Array.new
		matrixTable.each_with_index do |element,index|
			matrixTable.each_with_index do |element1,index1|

				x = element[:product_id]
				puts "here is the element #{element} while this is the product id => #{x} "

				if element["product_id"].to_i == element1["product_id"].to_i
					next
				end

				product_product_similarity = 0

				element["users"].each_with_index do |array_element,array_index|

					if array_element.to_i == element1["users"][array_index].to_i
						product_product_similarity = product_product_similarity + 1
					end
					
				end

				similarityTable << { "p1"=>element["product_id"].to_i,"p2"=>element1["product_id"].to_i,"similarity" => product_product_similarity }

			end
		end

		recomenderTable = Array.new
		similarityTable.each_with_index do |element,index|
			if(recomenderTable.count < 5)
				recomenderTable << element
			else
				index_element_to_remove = Recomend.get_index_min_in_similarity(similarityTable)
				recomenderTable[index_element_to_remove] = element
			end
		end


		result = { "table1" => user_product_table , "all_users" => all_users , "Matrix" => matrixTable,"similarity" => similarityTable , "Recommendations" => recomenderTable }
		render :json => result  
	end

end
