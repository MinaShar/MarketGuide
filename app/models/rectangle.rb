class Rectangle 

	attr_reader :x
	attr_reader :y  
	attr_reader :width 
	attr_reader :height 


	def initialize(x,y,width,height)
    	@x = x
    	@y = y
    	@width = width
    	@height = height
  	end

  	def is_containing(point)
  		if (point.x > @x and @x + @width >point.x) and (point.y > @y and @y + @height >point.y)
  			return true
  		else
  			return false	
  		end
  	end


    def self.create_rects_from_map_components(map_components)
        map_components_rects = []

        map_components.each do |row|
          if row['is_vertical']==1
            map_components_rects.push( Rectangle.new(row['X'],row['Y'],9,97) )
            else
            map_components_rects.push( Rectangle.new(row['X'],row['Y'],97,9) )
          end
          
        end

        return map_components_rects
    end

    def self.check_point_availability(point,map_components)

        map_components.each do |component|
          if component.is_containing(point)
            return false
          end
        end

        return true
    end

end
