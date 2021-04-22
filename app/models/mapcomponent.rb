class Mapcomponent < ApplicationRecord

	def self.add_new(x,y,is_vertical)
		ActiveRecord::Base.connection.exec_query("insert into mapcomponents ( `X`, `Y`, `is_vertical`, `created_at` , `updated_at`) values ( #{x} , #{y} , #{is_vertical} , NOW() , NOW() )")
	end

	def self.get_all
		result = ActiveRecord::Base.connection.exec_query("select * from mapcomponents")
		return result
	end

	def self.delete_every_thing
		ActiveRecord::Base.connection.exec_query("DELETE FROM `mapcomponents` ")
	end
end
