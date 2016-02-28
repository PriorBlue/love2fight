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
	obj.speed = data.speed or 100
	obj.jumpStrength = data.jumpStrength or 100
	obj.jumpDelay = data.jumpDelay or 1
	obj.jumpTime = 0
	obj.maxHealth = data.health or 100
	obj.health = obj.maxHealth
	obj.maxLifes = data.lifes or 3
	obj.color = data.color or {255, 255, 255}
	obj.controls = data.controls or {
		left = "a",
		right = "d",
		up = "w",
		down = "s",
	}
	obj.img = love.graphics.newImage(data.img)
	obj.shadow = love.graphics.newImage(data.shadow)
	obj.scale = data.scale
	obj.width = obj.img:getWidth() * obj.scale
	obj.height = obj.img:getHeight() * obj.scale
	obj.body = love.physics.newBody(phyWorld, obj.x, obj.y, "dynamic")
	obj.body:setFixedRotation(true)
	obj.shape = love.physics.newRectangleShape(obj.width, obj.height)
	obj.fixture = love.physics.newFixture(obj.body, obj.shape)
	obj.fixture:setFriction(0)
	obj.fixture:setUserData("Fighter")

	obj.update = function(dt)
		local x, y = obj.body:getLinearVelocity()

		if love.keyboard.isDown(obj.controls.left) then
			obj.body:setLinearVelocity(-obj.speed, y)
		elseif love.keyboard.isDown(obj.controls.right) then
			obj.body:setLinearVelocity(obj.speed, y)
		else
			obj.body:setLinearVelocity(0, y)
		end

		x, y = obj.body:getLinearVelocity()

		if obj.jumpTime < obj.jumpDelay then
			if love.keyboard.isDown(obj.controls.up) then
				obj.body:setLinearVelocity(x, -obj.jumpStrength)
				obj.jumpTime = obj.jumpTime + dt
			--elseif love.keyboard.isDown(obj.controls.down) then
				--obj.body:setLinearVelocity(x, obj.jumpStrength)
				--obj.jumpTime = obj.jumpTime + dt
			elseif obj.jumpTime > 0 then
				obj.jumpTime = obj.jumpDelay
			end
		elseif y < 0 then
			y = y * (1 - dt * 10)
			obj.body:setLinearVelocity(x, y)
		end

		obj.x = math.max(0, obj.x)
		obj.x = math.min(love.graphics.getWidth() - obj.width, obj.x)
		
		obj.x = obj.body:getX()
		obj.y = obj.body:getY()
	end

	obj.draw = function(x)
		local flip = (x > obj.x and -1 or 1)
		
		love.graphics.setColor(255, 255, 255, obj.y * 0.5)		
		love.graphics.draw(obj.shadow, obj.body:getX(), love.graphics.getHeight() - 16 / obj.scale, 0, obj.scale * flip, obj.scale, obj.width * 0.5, obj.height * 0.5)
		
		love.graphics.setColor(unpack(obj.color))
		love.graphics.draw(obj.img, obj.body:getX(), obj.body:getY(), 0, obj.scale * flip, obj.scale, obj.width * 0.5, obj.height * 0.5)
		
		love.graphics.setColor(255, 255, 255)
	end

	obj.coll = function(a, b, coll)
		local x, y = coll:getNormal()
		if (a == obj.fixture and y == 1) or (b == obj.fixture and y == -1) then
			obj.jumpTime = 0
		end
	end

	obj.getHealth = function()
	    return obj.health
	end
	return obj
end