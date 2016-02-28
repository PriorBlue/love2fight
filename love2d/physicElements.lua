function createPhysicsBox(x, y, width, height)
	local obj = {}

	obj.x = x or 0
	obj.y = y or 0
	obj.width = width or 32
	obj.height = height or 32
	obj.body = love.physics.newBody(phyWorld, obj.x, obj.y, "kinematic")
	obj.shape = love.physics.newRectangleShape(obj.width, obj.height)
	obj.fixture = love.physics.newFixture(obj.body, obj.shape)

	obj.draw = function()
		love.graphics.polygon("fill", obj.body:getWorldPoints(obj.shape:getPoints()))
	end

	return obj
end

function createPhysicsCircle(x, y, radius, typ)
	local obj = {}

	obj.body = love.physics.newBody(phyWorld, x, y, typ or "dynamic")
	obj.shape = love.physics.newCircleShape(radius)
	obj.fixture = love.physics.newFixture(obj.body, obj.shape)
	obj.fixture:setRestitution(1)
	obj.fixture:setFriction(0)

	obj.draw = function()
		love.graphics.circle("fill", obj.body:getX(), obj.body:getY(), obj.shape:getRadius())
	end

	return obj
end