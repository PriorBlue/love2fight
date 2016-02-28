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
	obj.attackTimer = 0
	obj.damaged = 0
	obj.attack = false
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
	obj.newImg = love.graphics.newImage(data.spriteBatchImage)
	obj.newImg:setWrap("repeat","repeat")
	local batchSizeX, batchSizeY = obj.newImg:getDimensions()
	obj.quadSizeX, obj.quadSizeY = batchSizeX / 4, batchSizeY / 2
	obj.spriteQuad = love.graphics.newQuad(0, 0, obj.quadSizeX, obj.quadSizeY, obj.newImg:getDimensions())
	obj.spriteImgPositions = {}
	for i = 1, 4 do
	    obj.spriteImgPositions[i] = {((i-1)%4)*obj.quadSizeX,0}
    end
	for i = 5, 8 do
	    obj.spriteImgPositions[i] = {((i-1)%4)*obj.quadSizeX, batchSizeY}
    end
    obj.currentSpriteImgID = 1
    obj.lastUpdate = 0
	obj.animationFrequency = 1/((data.speed/10) / data.scale)
	
	obj.img = love.graphics.newImage(data.img)
	obj.shadow = love.graphics.newImage(data.shadow)
	obj.scale = data.scale
	obj.width = obj.img:getWidth() * obj.scale
	obj.height = obj.img:getHeight() * obj.scale
	obj.body = love.physics.newBody(phyWorld, obj.x, obj.y, "dynamic")
	obj.body:setFixedRotation(true)
	obj.shape = love.physics.newRectangleShape(obj.width * 0.5, obj.height)
	obj.fixture = love.physics.newFixture(obj.body, obj.shape)
	obj.fixture:setFriction(0)
	obj.fixture:setUserData("Fighter")

 
	obj.body_hand = love.physics.newBody(phyWorld, obj.x, obj.y + 32 * obj.scale, "dynamic")
	obj.body_hand:setFixedRotation(true)
	obj.shape_hand = love.physics.newRectangleShape(336 * obj.scale, 64 * obj.scale)
	obj.fixture_hand = love.physics.newFixture(obj.body_hand, obj.shape_hand)
	obj.fixture_hand:setFriction(0)
	obj.fixture_hand:setSensor(true)
	obj.fixture_hand:setUserData("Weapon")

	obj.joint = love.physics.newWeldJoint( obj.body, obj.body_hand, 0, 0, false)

	obj.update = function(dt, fighter, joystick)
		local x, y = obj.body:getLinearVelocity()
	

		if love.keyboard.isDown(obj.controls.attack) or joyAttack then
			if obj.attack == false and obj.attackTimer == 0 then
				local coll = phyWorld:getContactList()
				
				for k, v in pairs(coll) do
					local a, b = v:getFixtures()
					
					if a:getUserData() == "Weapon" and a == obj.fixture_hand then
						if b:getUserData() == "Fighter" then
							fighter.health = fighter.health - 7
							fighter.damaged = 1
						end
					elseif b:getUserData() == "Weapon" and b == obj.fixture_hand then
						if a:getUserData() == "Fighter" then
							fighter.health = fighter.health - 7
							fighter.damaged = 1
						end
					end
				end
				
				obj.attack = true
				obj.attackTimer = 0.5
			end
		else
			obj.attack = false
		end
		
		obj.attackTimer = math.max(0, obj.attackTimer - dt)
		obj.damaged = math.max(0, obj.damaged - dt)
     
    if joystick then
        directionX, directionY, joyLt, rxDirectionX, rxDirectionY, joyRt = joystick:getAxes( )
        joyAttack = joystick:isGamepadDown("a")
      if not directionX then
        directionX=0
      end
      if not directionY then
        directionY=0
      end
      if directionX > (-0.2) and  directionX < (0.2) then
        directionX=0
      else
         obj.updateWalkCycle(dt)
      end
    else
      if love.keyboard.isDown(obj.controls.left) and not love.keyboard.isDown(obj.controls.right) then
			--obj.body:setLinearVelocity(-obj.speed, y)
      directionX = -1
       obj.updateWalkCycle(dt)
      elseif love.keyboard.isDown(obj.controls.right)and not love.keyboard.isDown(obj.controls.left) then
        --obj.body:setLinearVelocity(obj.speed, y)
        directionX = 1
         obj.updateWalkCycle(dt)
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
	
	obj.updateWalkCycle = function(dt)
    sfxLoopWalk = love.audio.newSource("sfx/crab.wav")
    sfxLoopWalk:setVolume(0.8)
    sfxLoopWalk:setLooping( false )
    love.audio.play(sfxLoopWalk)
  
	    obj.lastUpdate = obj.lastUpdate + dt
	    if obj.lastUpdate > obj.animationFrequency then
	        obj.lastUpdate = 0
            if obj.currentSpriteImgID < 4 then
                obj.currentSpriteImgID = obj.currentSpriteImgID + 1
            else
                obj.currentSpriteImgID = 1
            end
            local positions = obj.spriteImgPositions[obj.currentSpriteImgID]
            
            obj.spriteQuad:setViewport(positions[1],positions[2],obj.quadSizeX, obj.quadSizeY)
        end
	end

	obj.draw = function(x)
		local flip = (x > obj.x and -1 or 1)
		
		love.graphics.setColor(255, 255, 255, obj.y * 0.5)	
		love.graphics.draw(obj.shadow, obj.body:getX(), love.graphics.getHeight() - 64, 0, obj.scale * flip, obj.scale, obj.shadow:getWidth() * 0.5, obj.shadow:getHeight() * 0.5)
		
		love.graphics.setColor(obj.color[1], obj.color[2] * (1-obj.damaged), obj.color[3] * (1-obj.damaged))
		love.graphics.draw(obj.newImg, obj.spriteQuad, obj.body:getX(), obj.body:getY(), -obj.body:getAngle(), obj.scale * flip, obj.scale, obj.img:getWidth() * 0.5, obj.img:getHeight() * 0.5)
		
		--love.graphics.polygon("fill", obj.body:getWorldPoints(obj.shape:getPoints()))
		
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