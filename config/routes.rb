Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  get '/users', to: 'general#index'
  post '/login', to: 'general#login'
  post '/register', to: 'general#register'
  post '/TestRoute', to: 'general#test'
  post '/GetUserData', to: 'general#GetUserData'
  get '/previous_shopping_lists', to: 'general#previous_shopping_lists'
  get '/search_products', to: 'general#search_products'
  get '/products_of_shopping_list', to: 'general#products_of_shopping_list'
  get '/old_shopping_list', to: 'general#old_shopping_list'
  get '/get_all_chains', to: 'general#get_all_chains'
  get '/get_branches_of_chain', to: 'general#get_branches_of_chain'
  post '/add_new_list', to: 'general#add_new_list'
  get '/check_email_exist', to: 'general#check_email_exist'
  get '/get_map', to: 'general#get_map'
  get '/get_path', to: 'general#get_path2'
  get '/test', to: 'general#test2'
  get '/get_this_products', to: 'general#get_this_products'
  get '/get_area_data', to: 'general#get_area_data'


  ####### AUTHENTICATIONS ROUTES #######
  get '/', to: 'authentic#index'
  post '/AdminLoginAttempt', to: 'authentic#loginAttempt'
  post '/AdminLogin', to: 'authentic#login'


  ###########  ADMIN routes  ############
  get '/Admin', to: 'admin#index'
  get '/getMapPage', to: 'admin#getMapPage'
  post '/create_map', to: 'admin#create_map'
  get '/get_all_products', to: 'admin#get_all_products'
  post '/add_product_location', to: 'admin#add_product_location'
  get '/get_product_by_product_location_id', to: 'admin#get_product_by_product_location_id'
  get '/get_map_nodes', to: 'admin#get_map_nodes'


  ##############  RECOMENDER routes  ################
  get '/recomender/index', to: 'recomender#index'

  
  # this route must be removed
  get '/test_function', to: 'admin#test_function'
end
