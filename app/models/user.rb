class User < ApplicationRecord

	def self.getAll()
		result= ActiveRecord::Base.connection.exec_query("SELECT * from users")
		return result
	end

	def self.login(email,password)
		result=ActiveRecord::Base.connection.exec_query("select * from users where user_email='#{email}' and user_password='#{password}'")
		if(result.count > 0)
			return result[0]
		else
			return nil
		end
	end

	def self.register(name,date,gender,email,password,phone)
		ActiveRecord::Base.connection.exec_query("insert into users ( `user_name`, `user_email`, `user_phone`, `user_password`, `user_gender`, `user_dob` , `created_at` , `updated_at`) values ('#{name}','#{email}','#{phone}','#{password}','#{gender}','#{date}' , NOW() , NOW() )")
		
		result=ActiveRecord::Base.connection.exec_query("SELECT LAST_INSERT_ID() AS id;")

		result= ActiveRecord::Base.connection.exec_query("SELECT * from users where id=#{result[0]['id']}")
		return result[0]
	end

	def self.GetUserData(user_id)
		result=ActiveRecord::Base.connection.exec_query("select * from users where id=#{user_id} ")
		return result[0]
	end

	def self.check_email_exist(email)
		result=ActiveRecord::Base.connection.exec_query("select * from users where user_email='#{email}' ")
		if(result.count > 0)
			return 1
		else
			return -1
		end
	end

end
