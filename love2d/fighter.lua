function loadFighter(path, x, y)
	local data = dofile(path)
	data.x = x
	data.y = y
	
	return createFighter(data)
end

function createFighter(data)
	local obj = {}

	obj.x = data.x or 0
	obj.y = data.y or 0
	obj.width = data.width or 32
	obj.height = data.height or 32
	obj.speed = data.speed or 100
	obj.maxHealth = data.health or 100
	obj.maxLives = data.lives or 3
	obj.color = data.color or {255, 255, 255}
	obj.controls = data.controls or {
		left = "a",
		right = "d",
		up = "w",
		down = "s",
	}

	obj.update = function(dt)
		if love.keyboard.isDown(obj.controls.left) then
			obj.x = obj.x - dt * obj.speed
		end

		if love.keyboard.isDown(obj.controls.right) then
			obj.x = obj.x + dt * obj.speed
		end
		
		obj.x = math.max(0, obj.x)
		obj.x = math.min(love.graphics.getWidth() - obj.width, obj.x)
	end

	obj.draw = function()
		love.graphics.setColor(unpack(obj.color))
		love.graphics.rectangle("fill", obj.x, obj.y, obj.width, obj.height)
		love.graphics.setColor(255, 255, 255)
	end

	return obj
end