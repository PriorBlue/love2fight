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
	obj.pitch = data.pitch

    -- move animation
    obj.moveImg = love.graphics.newImage(data.moveImage)
    obj.moveImg:setWrap("repeat","repeat")
    local batchSizeX, batchSizeY = obj.moveImg:getDimensions()
    obj.quadSizeX, obj.quadSizeY = batchSizeX / 4, batchSizeY / 2
    obj.moveSpriteQuad = love.graphics.newQuad(0, 0, obj.quadSizeX, obj.quadSizeY, obj.moveImg:getDimensions())
    obj.moveImgPositions = {}
    for i = 1, 8 do
        obj.moveImgPositions[i] = {((i-1)%4)*obj.quadSizeX, ((i-1)/4 - (i-1)/4%1) * obj.quadSizeY}
    end
    obj.currentSpriteImgID = 1
    obj.lastMoveUpdate = 0
    obj.moveAnimationFrequency = 1/((data.speed/10) / data.scale)
    -- end of the move animation
    
    -- hit animation
    obj.hitImg = love.graphics.newImage(data.hitImage)
    obj.hitImg:setWrap("repeat","repeat")
    local batchSizeX, batchSizeY = obj.hitImg:getDimensions()
    obj.quadSizeX, obj.quadSizeY = batchSizeX / 4, batchSizeY / 4
    obj.hitSpriteQuad = love.graphics.newQuad(0, 0, obj.quadSizeX, obj.quadSizeY, obj.hitImg:getDimensions())
    obj.hitImgPositions = {}
    for i = 1, 9 do
        obj.hitImgPositions[i] = {((i-1)%4)*obj.quadSizeX, ((i-1)/4 - (i-1)/4%1) * obj.quadSizeY}
    end
    obj.hitSpriteImgID = 1
    obj.lastHitUpdate = 0
    obj.hitAnimationFrequency = 1/((data.speed/5) / data.scale)
    -- end of the hit animation
    
    -- light attack animation
    obj.lightAttackImg = love.graphics.newImage(data.lAttackImage)
    obj.lightAttackImg:setWrap("repeat","repeat")
    local batchSizeX, batchSizeY = obj.lightAttackImg:getDimensions()
    obj.lAttackQuadSizeX, obj.lAttackQuadSizeY = batchSizeX / 4, batchSizeY / 4
    obj.lAttackSpriteQuad = love.graphics.newQuad(0, 0, obj.lAttackQuadSizeX, obj.lAttackQuadSizeY, obj.lightAttackImg:getDimensions())
    obj.lAttackSpriteImgPositions = {}
    for i = 1, 9 do
        obj.lAttackSpriteImgPositions[i] = {((i-1)%4)*obj.lAttackQuadSizeX, ((i-1)/4 - (i-1)/4%1)* obj.lAttackQuadSizeY}
    end
    
    obj.lAttackSpriteImgID = 1
    obj.lastlAttackUpdate = 0
    obj.lAttackAnimationFrequency = 1/((data.speed/5) / data.scale)
    -- end of the light attack animation
    
    -- heavy attack animation
    obj.heavyAttackImg = love.graphics.newImage(data.hAttackImage)
    obj.heavyAttackImg:setWrap("repeat","repeat")
    local batchSizeX, batchSizeY = obj.heavyAttackImg:getDimensions()
    obj.hAttackQuadSizeX, obj.hAttackQuadSizeY = batchSizeX / 4, batchSizeY / 4
    obj.hAttackSpriteQuad = love.graphics.newQuad(0, 0, obj.hAttackQuadSizeX, obj.hAttackQuadSizeY, obj.heavyAttackImg:getDimensions())
    obj.hAttackSpriteImgPositions = {}
    for i = 1, 13 do
        obj.hAttackSpriteImgPositions[i] = {((i-1)%4)*obj.hAttackQuadSizeX, ((i-1)/4 - (i-1)/4%1) * obj.hAttackQuadSizeY}
    end
    obj.hAttackSpriteImgPositions[13] = {0, 3*obj.hAttackQuadSizeY}
    
    obj.hAttackSpriteImgID = 1
    obj.lasthAttackUpdate = 0
    obj.hAttackAnimationFrequency = 1/((data.speed/5) / data.scale)
    -- end of the heavy attack animation

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

 
	obj.body_hand = love.physics.newBody(phyWorld, obj.x, obj.y - 32 * obj.scale, "dynamic")
	obj.body_hand:setFixedRotation(true)
	obj.shape_hand = love.physics.newRectangleShape(336 * obj.scale, 64 * obj.scale)
	obj.fixture_hand = love.physics.newFixture(obj.body_hand, obj.shape_hand)
	obj.fixture_hand:setFriction(0)
	obj.fixture_hand:setSensor(true)
	obj.fixture_hand:setUserData("Weapon")

	obj.joint = love.physics.newWeldJoint( obj.body, obj.body_hand, 0, 0, false)
	obj.hitAnimLastHealth = obj.health
	
	obj.update = function(dt, fighter, joystick)
		local x, y = obj.body:getLinearVelocity()
		
		if obj.hitAnimLastHealth > obj.health then
            obj.animationStatus = 4
            obj.hitAnimLastHealth = obj.health
        end

		if love.keyboard.isDown(obj.controls.attack) or obj.controls.jayAttack then
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
				obj.animationStatus = 2
				obj.attackTimer = 0.5
			end
        elseif love.keyboard.isDown(obj.controls.attack2) or obj.controls.jayAttack2 then
			if obj.attack == false and obj.attackTimer == 0 then
				local coll = phyWorld:getContactList()
				
				for k, v in pairs(coll) do
					local a, b = v:getFixtures()
					
					if a:getUserData() == "Weapon" and a == obj.fixture_hand then
						if b:getUserData() == "Fighter" then
							fighter.health = fighter.health - 15
							fighter.damaged = 1
						end
					elseif b:getUserData() == "Weapon" and b == obj.fixture_hand then
						if a:getUserData() == "Fighter" then
							fighter.health = fighter.health - 15
							fighter.damaged = 1
						end
					end
				end
				
				obj.attack = true
				obj.animationStatus = 3
				obj.attackTimer = 1.1
			end
		else
			obj.attack = false
		end
		obj.updateAnimation(dt)
		obj.attackTimer = math.max(0, obj.attackTimer - dt)
		obj.damaged = math.max(0, obj.damaged - dt * 2)
     
    if joystick then
        directionX, directionY, joyLt, rxDirectionX, rxDirectionY, joyRt = joystick:getAxes( )
       -- joyAttack = joystick:isGamepadDown("a")        
        --joyAttack2 = joystick:isGamepadDown("b")
        obj.controls.jayAttack = joystick:isGamepadDown("a")             
        obj.controls.jayAttack2 = joystick:isGamepadDown("b")     


      if not directionX then
        directionX=0
      end
      if not directionY then
        directionY=0
      end
      if directionX > (-0.2) and  directionX < (0.2) then
        directionX=0
      else
         obj.animationStatus = 1
      end
    else
      if love.keyboard.isDown(obj.controls.left) and not love.keyboard.isDown(obj.controls.right) then
			--obj.body:setLinearVelocity(-obj.speed, y)
      directionX = -1
       obj.animationStatus = 1
      elseif love.keyboard.isDown(obj.controls.right)and not love.keyboard.isDown(obj.controls.left) then
        --obj.body:setLinearVelocity(obj.speed, y)
        directionX = 1
         obj.animationStatus = 1
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
		if beachmode then
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
		end
 
		obj.x = math.max(0, obj.x)
		obj.x = math.min(love.graphics.getWidth() - obj.width, obj.x)
		
		obj.x = obj.body:getX()
		obj.y = obj.body:getY()
	end
	
	--obj.updateWalkCycle = function(dt)

	-- 0 = default/stand, 1 = move, 2 = light attack, 3 = heavy attack, 4 = hit
	obj.animationStatus = 0
	obj.updateAnimation = function(dt)
        if obj.animationStatus == 4 then
            if obj.lastHitUpdate > obj.hitAnimationFrequency then
                obj.lastHitUpdate = 0
	            if not (obj.hitSpriteImgID == 0) then
                    -- continue hit animation
                    if obj.hitSpriteImgID < 9 then
                        obj.hitSpriteImgID = obj.hitSpriteImgID + 1
                    else
                        obj.hitSpriteImgID = 1
                        obj.animationStatus = 0
                    end
	                local positions = obj.hitImgPositions[obj.hitSpriteImgID]
	                obj.hitSpriteQuad:setViewport(positions[1],positions[2],obj.quadSizeX, obj.quadSizeY)
                else
                    -- start hit animation
                    obj.animationStatus = 4
                    obj.hitSpriteImgID = 1
                    local positions = obj.hitImgPositions[1]
                    obj.hitSpriteQuad:setViewport(positions[1],positions[2],obj.quadSizeX, obj.quadSizeY)
                end
            end
            obj.lastHitUpdate = obj.lastHitUpdate + dt
        elseif obj.animationStatus == 3 then
            if obj.lasthAttackUpdate > obj.hAttackAnimationFrequency then
                obj.lasthAttackUpdate = 0
                if not (obj.hAttackSpriteImgID == 0) then
                    local positions = obj.hAttackSpriteImgPositions[obj.hAttackSpriteImgID]
                    obj.hAttackSpriteQuad:setViewport(positions[1],positions[2],obj.quadSizeX, obj.quadSizeY)
                    -- continue heavy attack animation
                    if obj.hAttackSpriteImgID < 13 then
                        obj.hAttackSpriteImgID = obj.hAttackSpriteImgID + 1
                    else
                        obj.hAttackSpriteImgID = 0
                        obj.animationStatus = 0
                    end
                else
                    -- start heavy attack animation
                    obj.animationStatus = 3
                    obj.hAttackSpriteImgID = 1
                    local positions = obj.hAttackSpriteImgPositions[1]
                    obj.hAttackSpriteQuad:setViewport(positions[1],positions[2],obj.quadSizeX, obj.quadSizeY)
                end
            end
            obj.lasthAttackUpdate = obj.lasthAttackUpdate + dt
        elseif obj.animationStatus == 2 then
            if obj.lastlAttackUpdate > obj.lAttackAnimationFrequency then
                obj.lastlAttackUpdate = 0
                if not (obj.lAttackSpriteImgID == 0) then
                    local positions = obj.lAttackSpriteImgPositions[obj.lAttackSpriteImgID]
                    obj.lAttackSpriteQuad:setViewport(positions[1],positions[2],obj.quadSizeX, obj.quadSizeY)
                    -- continue attack animation
                    if obj.lAttackSpriteImgID < 9 then
                        obj.lAttackSpriteImgID = obj.lAttackSpriteImgID + 1
                    else
                        obj.lAttackSpriteImgID = 0
                        obj.animationStatus = 0
                    end
                else
                    -- start attack animation
                    obj.animationStatus = 2
                    obj.lAttackSpriteImgID = 1
                    local positions = obj.lAttackSpriteImgPositions[1]
                    obj.lAttackSpriteQuad:setViewport(positions[1],positions[2],obj.quadSizeX, obj.quadSizeY)
                end
            end
            obj.lastlAttackUpdate = obj.lastlAttackUpdate + dt
        elseif obj.animationStatus == 1 then
            if obj.lastMoveUpdate > obj.moveAnimationFrequency then
                sfxLoopWalk = love.audio.newSource("sfx/crab.wav", "static")
                --sfxLoopWalk = love.audio.newSource("sfx/crab.wav")
                sfxLoopWalk:setVolume(0.3)
                sfxLoopWalk:setLooping(false)
                pitch = (obj.pitch)
                if pitch == nil then
                  pitch =10
                end
                sfxLoopWalk:setPitch(pitch) -- one octave lower
             
                love.audio.play(sfxLoopWalk)
                obj.lastMoveUpdate = 0
                --continue move animation
                if obj.currentSpriteImgID < 8 then
                    obj.currentSpriteImgID = obj.currentSpriteImgID + 1
                else
                    obj.currentSpriteImgID = 1
                end
                local positions = obj.moveImgPositions[obj.currentSpriteImgID]
                obj.moveSpriteQuad:setViewport(positions[1],positions[2],obj.quadSizeX, obj.quadSizeY)
                obj.animationStatus = 0
            end
        end
        obj.lastMoveUpdate = obj.lastMoveUpdate + dt
	end

	obj.draw = function(x)
		local flip = (x > obj.x and 1 or -1)
		
		love.graphics.setColor(255, 255, 255, obj.y * 0.5)	
		love.graphics.draw(obj.shadow, obj.body:getX(), love.graphics.getHeight() - 128, 0, obj.scale * flip, obj.scale, obj.shadow:getWidth() * 0.5, obj.shadow:getHeight() * 0.5)

		love.graphics.setColor(obj.color[1], obj.color[2] * (1-obj.damaged), obj.color[3] * (1-obj.damaged))
		if obj.animationStatus == 4 then
		    love.graphics.draw(obj.hitImg, obj.hitSpriteQuad, obj.body:getX(), obj.body:getY(), -obj.body:getAngle(), obj.scale * flip, obj.scale, obj.img:getWidth() * 0.5, obj.img:getHeight() * 0.5)
        elseif obj.animationStatus == 3 then
            love.graphics.draw(obj.heavyAttackImg, obj.hAttackSpriteQuad, obj.body:getX(), obj.body:getY(), -obj.body:getAngle(), obj.scale * flip, obj.scale, obj.img:getWidth() * 0.5, obj.img:getHeight() * 0.5)
		elseif obj.animationStatus == 2 then
            love.graphics.draw(obj.lightAttackImg, obj.lAttackSpriteQuad, obj.body:getX(), obj.body:getY(), -obj.body:getAngle(), obj.scale * flip, obj.scale, obj.img:getWidth() * 0.5, obj.img:getHeight() * 0.5)
        else
		    love.graphics.draw(obj.moveImg, obj.moveSpriteQuad, obj.body:getX(), obj.body:getY(), -obj.body:getAngle(), obj.scale * flip, obj.scale, obj.img:getWidth() * 0.5, obj.img:getHeight() * 0.5)
        end
		
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