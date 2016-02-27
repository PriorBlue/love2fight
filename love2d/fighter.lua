function createFighter(x, y, width, height, speed)
	local obj = {}

	obj.x = x
	obj.y = y
	obj.width = width
	obj.height = height
	obj.speed = speed

	obj.update = function(dt)
		if love.keyboard.isDown("a") then
			obj.x = obj.x - dt * obj.speed
		end

		if love.keyboard.isDown("d") then
			obj.x = obj.x + dt * obj.speed
		end
		
		obj.x = math.max(0, obj.x)
		obj.x = math.min(love.graphics.getWidth() - obj.width, obj.x)
	end

	obj.draw = function()
		love.graphics.rectangle("fill", obj.x, obj.y, obj.width, obj.height)
	end

	return obj
end