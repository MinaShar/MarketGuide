# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Product.create([{ name: 'product 1' , created_at: Time.now.to_datetime , updated_at: Time.now.to_datetime },
				{ name: 'product 2' , created_at: Time.now.to_datetime , updated_at: Time.now.to_datetime },
				{ name: 'product 3' , created_at: Time.now.to_datetime , updated_at: Time.now.to_datetime },
				{ name: 'product 4' , created_at: Time.now.to_datetime , updated_at: Time.now.to_datetime },
				{ name: 'product 5' , created_at: Time.now.to_datetime , updated_at: Time.now.to_datetime },
				{ name: 'product 6' , created_at: Time.now.to_datetime , updated_at: Time.now.to_datetime },
				{ name: 'product 7' , created_at: Time.now.to_datetime , updated_at: Time.now.to_datetime },
				{ name: 'product 8' , created_at: Time.now.to_datetime , updated_at: Time.now.to_datetime },
				{ name: 'product 9' , created_at: Time.now.to_datetime , updated_at: Time.now.to_datetime },
				{ name: 'product 10' , created_at: Time.now.to_datetime , updated_at: Time.now.to_datetime }])

Chain.create([{ id: 1 , name: 'chain 1' , created_at: Time.now.to_datetime , updated_at: Time.now.to_datetime },
			  { id: 2 , name: 'chain 2' , created_at: Time.now.to_datetime , updated_at: Time.now.to_datetime },
			  { id: 3 , name: 'chain 3' , created_at: Time.now.to_datetime , updated_at: Time.now.to_datetime }])

Branch.create([{ chain_id: 1 , name: 'branch 1 for chain 1' , created_at: Time.now.to_datetime , updated_at: Time.now.to_datetime },
			   { chain_id: 1 , name: 'branch 2 for chain 1' , created_at: Time.now.to_datetime , updated_at: Time.now.to_datetime },
			   { chain_id: 1 , name: 'branch 3 for chain 1' , created_at: Time.now.to_datetime , updated_at: Time.now.to_datetime },
			   { chain_id: 2 , name: 'branch 1 for chain 2' , created_at: Time.now.to_datetime , updated_at: Time.now.to_datetime },
			   { chain_id: 2 , name: 'branch 2 for chain 2' , created_at: Time.now.to_datetime , updated_at: Time.now.to_datetime },
			   { chain_id: 2 , name: 'branch 3 for chain 2' , created_at: Time.now.to_datetime , updated_at: Time.now.to_datetime },
			   { chain_id: 3 , name: 'branch 1 for chain 3' , created_at: Time.now.to_datetime , updated_at: Time.now.to_datetime },
			   { chain_id: 3 , name: 'branch 2 for chain 3' , created_at: Time.now.to_datetime , updated_at: Time.now.to_datetime },
			   { chain_id: 3 , name: 'branch 3 for chain 3' , created_at: Time.now.to_datetime , updated_at: Time.now.to_datetime }])