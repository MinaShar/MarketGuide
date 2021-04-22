class Pointonroute 

	attr_reader :point
	attr_reader :is_reached
	attr_reader :distance_to_this_point


	attr_accessor :point
	attr_accessor :is_reached
	attr_accessor :distance_to_this_point

	def initialize(point,is_reached)
    	@point = point
    	@is_reached = is_reached
    	@distance_to_this_point = -1
  	end


  	def self.is_all_reached(array)
  		
  		array.each do |e|
  			if e.is_reached == false
  				return false
  			end
  			# puts "is_reached => #{e.is_reached}"
  		end
  		return true
  	end
end
