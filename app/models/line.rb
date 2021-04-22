class Line

	attr_accessor :point1
	attr_accessor :point2

	attr_reader :point1
	attr_reader :point2


	def initialize(point1,point2)
		@point1 = point1
		@point2 = point2
	end

	def is_intersecting(map_component)

		slope = ( @point1.y * 1.0 - @point2.y * 1.0 ) / ( @point1.x * 1.0 - @point2.x * 1.0 )
		puts "slope equale ===> #{slope}"
		interteption_of_y = @point1.y * 1.0 - slope * @point1.x * 1.0
		puts "intercepted part ====> #{interteption_of_y}"
		is_vertical = map_component['is_vertical'].to_i
		puts "is_vertical ========> #{is_vertical}"


		if is_vertical == 1
			# VERTICAL
			if slope.to_f == Float::NAN or slope.to_f == Float::INFINITY or slope.to_f == Float::INFINITY * -1.0 or slope >= 57.0 or slope <= -57.0
				puts "line is parallel to y-axix"
				if ( ( @point1.y <= map_component['Y'].to_f and @point2.y >= map_component['Y'].to_f ) or ( @point1.y >= map_component['Y'].to_f and @point2.y <= map_component['Y'].to_f ) ) and ( map_component['X'].to_f - 5.0 <= @point1.x and map_component['X'].to_f + 9.0 >= @point1.x )
					return true
				else
					return false
				end
			end

			# parallel to x-axis
			if slope.to_f <= 0.1 and slope.to_f >= -0.1
				puts "line is parallel to x-axis"
				if ((map_component['X'].to_f >= @point1.x and map_component['X'].to_f <= @point2.x) or (map_component['X'].to_f >= @point2.x and map_component['X'].to_f <= @point1.x)) and (map_component['Y'].to_f <= @point1.y and (map_component['Y'].to_f + 97.0) >= @point1.y)
					return true
				else
					return false
				end
			end

			intercepted_y = map_component['X'].to_f  * slope * 1.0 + interteption_of_y * 1.0 
			if (( intercepted_y >= map_component['Y'].to_f ) and ( intercepted_y <= (map_component['Y'].to_f + 97.0) )) and ( (@point1.x <=map_component['X'].to_f and @point2.x >= map_component['X'].to_f) or (@point2.x <=map_component['X'].to_f and @point1.x >= map_component['X'].to_f) )
				return true
			end

			r = map_component['X'].to_f + 9.0
			intercepted_y = r * slope * 1.0 + interteption_of_y * 1.0 
			if (( intercepted_y >= map_component['Y'].to_f ) and ( intercepted_y <= (map_component['Y'].to_f + 97.0) )) and ( (@point1.x <=map_component['X'].to_f and @point2.x >= map_component['X'].to_f) or (@point2.x <=map_component['X'].to_f and @point1.x >= map_component['X'].to_f) )
				return true
			end

		else
			# HORIZONTAL
			if slope.to_f == Float::NAN or slope.to_f == Float::INFINITY or slope.to_f == Float::INFINITY * -1.0 or slope >= 57.0 or slope <= -57.0
				puts "line is parallel to y-axix"
				if (@point1.x >= map_component['X'].to_f and @point1.x <= map_component['X'].to_f + 97.0 ) and ( (@point1.y <= map_component['Y'].to_f and @point2.y >= map_component['Y'].to_f) or (@point2.y <= map_component['Y'].to_f and @point1.y >= map_component['Y'].to_f) )
					return true
				else
					return false
				end
			end

			# parallel to x-axis
			if slope.to_f <= 0.1 and slope.to_f >= -0.1
				puts "line is parallel to x-axis"
				if ((@point1.y >= map_component['Y'].to_f and @point1.y <= map_component['Y'].to_f + 9.0) and (@point1.x >=map_component['X'].to_f and @point1.x <= map_component['X'].to_f + 97.0)) or ( (@point2.y >= map_component['Y'].to_f and @point2.y <= map_component['Y'].to_f + 9.0) and (@point2.x >=map_component['X'].to_f and @point2.x <= map_component['X'].to_f + 97.0) ) or (@point1.y >= map_component['Y'].to_f and @point1.y <= map_component['Y'].to_f + 9.0 and ((@point1.x<=map_component['X'].to_f and @point2.x >=map_component['X'].to_f + 97.0) or (@point2.x<=map_component['X'].to_f and @point1.x >=map_component['X'].to_f + 97.0)) )
					return true
				else
					return false 
				end
			end

			intercepted_x = ( map_component['Y'].to_f - interteption_of_y * 1.0 ) / slope * 1.0
			if (( intercepted_x >= map_component['X'].to_f ) and ( intercepted_x <= (map_component['X'].to_f + 97.0) ) ) and ( ( @point1.y <= map_component['Y'].to_f and @point2.y >= map_component['Y'].to_f) or ( @point2.y <= map_component['Y'].to_f and @point1.y >= map_component['Y'].to_f) )
				puts "intercepted_x ==> #{intercepted_x}"
				puts "first case"
				puts "intercepted x lies between #{map_component['X'].to_f} & #{map_component['X'].to_f + 97.0}"
				return true
			end

			r = map_component['Y'].to_f + 9.0
			intercepted_x = ( r - interteption_of_y * 1.0 ) / slope * 1.0
			if (( intercepted_x >= map_component['X'].to_f ) and ( intercepted_x <= (map_component['X'].to_f + 97.0) )) and ( ( @point1.y <= map_component['Y'].to_f and @point2.y >= map_component['Y'].to_f) or ( @point2.y <= map_component['Y'].to_f and @point1.y >= map_component['Y'].to_f) )
				puts "intercepted_x ==> #{intercepted_x}"
				puts "second case"
				puts "intercepted x lies between #{map_component['X'].to_f} & #{map_component['X'].to_f + 97.0}"
				return true
			end
		end

		return false
	end

	def self.deistance_between(point1,point2)

		horizontal = point1.x - point2.x
		vertical = point1.y - point2.y
		diancesquared = vertical ** 2 + horizontal ** 2

		return Math.sqrt(diancesquared)
	end


	def self.decide_next_destination(current_location,points_on_route)
		
		next_destination = nil
		points_on_route.each do |e|  
			if e.is_reached == false
				e.distance_to_this_point = Line.deistance_between(current_location,e.point)
			end
		end

		points_on_route.each do |e|  
			if e.is_reached == false and next_destination == nil
				next_destination = e
			elsif e.is_reached == false and next_destination != nil
				if e.distance_to_this_point < next_destination.distance_to_this_point
					next_destination = e
				end
			end
		end

		return next_destination
	end

end
