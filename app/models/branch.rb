class Branch < ApplicationRecord

	def self.get_branches_of_chain(chain_id)
		result=ActiveRecord::Base.connection.exec_query("select * from branches where chain_id=#{chain_id}")
		return result
	end
end
