class Chain < ApplicationRecord

	def self.get_all
		result=ActiveRecord::Base.connection.exec_query("select * from chains")
		return result
	end

end
