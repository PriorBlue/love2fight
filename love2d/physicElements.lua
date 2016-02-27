function createPhysicsBox(x, y, width, height)
	local obj = {}

	obj.x = x or 0
	obj.y = y or 0
	obj.width = width or 32
	obj.height = height or 32
	obj.body = love.physics.newBody(phyWorld, obj.x, obj.y, "kinematic")
	obj.shape = love.physics.newRectangleShape(obj.width, obj.height)
	obj.fixture = love.physics.newFixture(obj.body, obj.shape)

	return obj
end