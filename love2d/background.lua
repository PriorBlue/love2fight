function createBackground (x, y, pictureName, speed, isQuad, width, height) 

  local obj = {}
  obj.x = x
  obj.y = y
  obj.px = 0
  
  obj.image = love.graphics.newImage(pictureName)

  obj.isQuad = isQuad or false
  obj.width = width or obj.image:getWidth()
  obj.height = height or obj.image:getHeight()
  
  
  obj.image:setWrap("repeat", "repeat")
  obj.speed = speed
  
   
  obj.Quad= love.graphics.newQuad (obj.x, obj.y, obj.width, obj.height,  obj.image:getWidth(), obj.image:getHeight()) 
  --obj.Quad:setViewport( x, y, w, h )
  
	obj.update = function(dt, cam)
		obj.px = cam.x * obj.speed * 0.1
	end
  
  obj.draw = function()      
    if obj.isQuad then
    obj.Quad:setViewport( -obj.px, 0,  obj.width, obj.height)
      love.graphics.draw(obj.image, obj.Quad, obj.x, obj.y)
    else
      love.graphics.draw(obj.image, obj.x - obj.px, obj.y)
    end
  end    
  
 return obj  
end