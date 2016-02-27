local tempx = 1
function animateClouds (dt, clouds) 

  for k,v in pairs (clouds) do
    if (math.mod(k,2) == 0) then
      v.x = v.x + dt * 3 * math.sin(love.timer.getTime())  
      v.y = v.y + dt * 3 *  math.cos(love.timer.getTime()) 
    
    else
      v.x = v.x + dt * (-4) * math.sin(love.timer.getTime())  
      v.y = v.y + dt * (-5) * math.cos(love.timer.getTime()) 
    end
  end

end