class Mapregion < ApplicationRecord

	def self.add_new(x,y,width,height,r,g,b,name)
		ActiveRecord::Base.connection.exec_query("insert into mapregions (`x`,`y`,`width`,`height`,`r`,`g`,`b`,`created_at`,`updated_at`,`name`) values (#{x},#{y},#{width},#{height},#{r},#{g},#{b},NOW(),NOW(),'#{name}')")
	end

	def self.delete_every_thing()
		ActiveRecord::Base.connection.exec_query("delete from mapregions")
	end

	def self.get_all()
		result = ActiveRecord::Base.connection.exec_query("select * from mapregions")
		return result
	end
end
