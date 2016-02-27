function createBackground (x, y, pictureName) 

  local obj = {}
  obj.x = x
  obj.y = y

  obj.image = love.graphics.newImage(pictureName)


  obj.draw = function()
      
      love.graphics.draw(obj.image, obj.x, obj.y)
      love.graphics.rectangle("fill", 20, 50, 60, 120 )
      
    end
return obj

end
