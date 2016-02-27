function createBackground (x, y, pictureName, speed) 

  local obj = {}
  obj.x = x
  obj.y = y

  obj.image = love.graphics.newImage(pictureName)
  obj.speed = speed
  
  obj.update = function(dt, xFigt1, xFigt2)
    canMoveBackVar = canMoveBack(xFigt1, xFigt2)
    if canMoveBackVar == true then
      if love.keyboard.isDown("a") then
        obj.x = obj.x + dt * obj.speed
      end

      if love.keyboard.isDown("d") then
        obj.x = obj.x - dt * obj.speed
      end
      
      --[[
      obj.x = math.max(-10, obj.x)
      obj.x = math.min(love.graphics.getWidth() + 50, obj.x)
      ]]--
      
    end
		
	end
  
  obj.draw = function()      
      love.graphics.draw(obj.image, obj.x, obj.y)
      --love.graphics.rectangle("fill", 20, 50, 60, 120 )
  end    
  
 return obj  
end

function canMoveBack (x1, x2) 
    if (x1 > 0 and x1 < love.graphics.getWidth()-33) and (x2 > 0 and x2 < love.graphics.getWidth()-65) then
      return true
    else
      return false
    end
  end