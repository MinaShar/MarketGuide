class Point 

	attr_reader :x
	attr_reader :y
	attr_reader :distance_from_this_point_to_destination
	attr_reader :is_available_flag

	attr_accessor :distance_from_this_point_to_destination
	attr_accessor :is_available_flag

	def initialize(x,y)
    	@x = x
    	@y = y
  	end

  	def branch_on_point
  		branches = []

  		branches.push(Point.new(@x+1,@y))
  		branches.push(Point.new(@x-1,@y))
  		branches.push(Point.new(@x,@y+1))
  		branches.push(Point.new(@x,@y-1))
  		return branches
  	end


    def self.is_point_selected_before(point,path)
        path.each do |p|
          if p.x == point.x and p.y == point.y
            return true
          end
        end
        return false
    end


  	def self.reach_from_to(current,destination,path,map_components)
  		last_place = current
  		puts "NOW THE CURRENT PLACE IS (#{current.x},#{current.y})"
  		while true


        # must be removed >> for testing only
        if path.count > 4000
          puts 'points reached the limit permitted'
          break
        end
        ##################

  			if Line.deistance_between(last_place,destination) < 40 
  				break
  			end	
  			
  			available_points=last_place.branch_on_point()

  			available_points.each do |p|
  				p.distance_from_this_point_to_destination = Line.deistance_between(p,destination)
  				p.is_available_flag = Rectangle.check_point_availability(p,map_components)
  			end

        point_to_test_with = nil

        if path.count > 2
          point_to_test_with = path[path.count - 2]
        end

  			best_next_step = nil

  			available_points.each do |p|
  				if p.is_available_flag == true and best_next_step == nil
  					best_next_step = p
  				elsif p.is_available_flag == true and p.distance_from_this_point_to_destination < best_next_step.distance_from_this_point_to_destination and point_to_test_with == nil 
  					best_next_step = p

          elsif p.is_available_flag == true and p.distance_from_this_point_to_destination < best_next_step.distance_from_this_point_to_destination and Point.is_point_selected_before(p,path) == true
            next_step_if_there_is = nil
            Point.special_case(p,destination,path,map_components,next_step_if_there_is)
            if next_step_if_there_is != nil and next_step_if_there_is.distance_from_this_point_to_destination < best_next_step.distance_from_this_point_to_destination
              best_next_step = next_step_if_there_is
            end
              
          elsif p.is_available_flag == true and p.distance_from_this_point_to_destination < best_next_step.distance_from_this_point_to_destination and ( point_to_test_with.x != p.x or point_to_test_with.y != p.y ) and Point.is_point_selected_before(p,path) == false
            best_next_step = p
  				end
  			end
  			last_place = best_next_step
  			path.push(best_next_step)
  			puts "path => (#{best_next_step.x},#{best_next_step.y}) => path length = #{path.count} "
  		end
  	
  	end


    def self.special_case(point_on_path,destination,path,map_components,next_step_if_there_is)
      puts 'we found point on path'
      available_points=point_on_path.branch_on_point()

      available_points.each do |p|
        p.distance_from_this_point_to_destination = Line.deistance_between(p,destination)
        p.is_available_flag = ( Rectangle.check_point_availability(p,map_components) ) #and ( !Point.is_point_selected_before(p,path) )
      end

      best_next_step = nil
      available_points.each do |p|
        if best_next_step == nil and p.is_available_flag == true
          best_next_step = p
        elsif p.is_available_flag == true and p.distance_from_this_point_to_destination < best_next_step.distance_from_this_point_to_destination 
          best_next_step = p
        end
      end

      if best_next_step != nil
        next_step_if_there_is = best_next_step
      else
        next_step_if_there_is = nil
      end

    end

end
