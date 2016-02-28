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
	obj.body = love.physics.newBody(phyWorld, obj.x, obj.y, "dynamic")
	obj.body:setFixedRotation(true)
	obj.shape = love.physics.newRectangleShape(obj.width, obj.height)
	obj.fixture = love.physics.newFixture(obj.body, obj.shape)
	obj.fixture:setFriction(0)
	obj.fixture:setUserData("Fighter")

    
	obj.update = function(dt, joystick)
		local x, y = obj.body:getLinearVelocity()


    
    if joystick then
        directionX, directionY, joyLt, rxDirectionX, rxDirectionY, joyRt = joystick:getAxes( )
      if not directionX then
        directionX=0
      end
      if not directionY then
        directionY=0
      end
      if directionX > (-0.2) and  directionX < (0.2) then
        directionX=0
      end
    else
      if love.keyboard.isDown(obj.controls.left) and not love.keyboard.isDown(obj.controls.right) then
			--obj.body:setLinearVelocity(-obj.speed, y)
      directionX = -1
      elseif love.keyboard.isDown(obj.controls.right)and not love.keyboard.isDown(obj.controls.left) then
        --obj.body:setLinearVelocity(obj.speed, y)
        directionX = 1
      else
        obj.body:setLinearVelocity(0, y)
        directionX=0
      end
      
      if love.keyboard.isDown(obj.controls.up) then
        directionY = -1
      else  
        directionY = 0
      end
    end
		x, y = obj.body:getLinearVelocity()

    obj.body:setLinearVelocity(obj.speed * directionX, y)
    print (directionX)
 
		if obj.jumpTime < obj.jumpDelay then
			if directionY < -0.2 then
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

	obj.draw = function()
		love.graphics.setColor(unpack(obj.color))
		love.graphics.rectangle("fill", obj.body:getX() - obj.width * 0.5, obj.body:getY() - obj.height * 0.5, obj.width, obj.height)
		love.graphics.setColor(255, 255, 255)
	end

	obj.coll = function(a, b, coll)
		local x, y = coll:getNormal()
		if (a == obj.fixture and y == 1) or (b == obj.fixture and y == -1) then
			obj.jumpTime = 0
		end
	end

	obj.getHealth = function()
	    if obj.health > 0 then
	        obj.health = obj.health - 0.1
	    end
	    return obj.health
	end
	return obj
end