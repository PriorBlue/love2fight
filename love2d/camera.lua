function createCamera(objects)
	local obj = {}

	obj.objects = objects
	obj.x = 0
	obj.y = 0

	obj.update = function(dt)
		local cnt = 0
		obj.x = 0
		
		for k, v in pairs(obj.objects) do
			cnt = cnt + 1
			obj.x = obj.x + v.x
		end
		
		obj.x = obj.x / cnt
	end
	
	obj.trans = function()
		love.graphics.translate(-obj.x + love.graphics.getWidth() * 0.5, 0)
	end
	
	obj.untrans = function()
		love.graphics.translate(obj.x - love.graphics.getWidth() * 0.5, 0)
	end

	return obj
end