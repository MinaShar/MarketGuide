class AuthenticController < ApplicationController

	skip_before_filter :verify_authenticity_token  

	def index
		
	end

	def loginAttempt
		
		#### CHECK IN DB #######
		########################
		response = { 'code' => 1  }
		render :json => response   
	end

	def login
		redirect_to '/Admin'
	end
end
