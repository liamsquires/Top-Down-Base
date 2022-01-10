player = {}

function player.load( ... )

	player.maxSpeed = 9
	player.traction = 0.5
	player.acceleration = 1

	--Player Definitions: starts in center
	player.x = love.graphics.getWidth() / 2
	player.y = love.graphics.getHeight() / 2
	player.direction = 0
	player.health = 5
	player.moving = false
    player.velocity = 0
	player.yVelocity = 0
	player.xVelocity = 0
	player.boosting = 1
end


function player.update(dt)
	
	player.move(dt)

end

function player.alterMovement()
	if love.mouse.isDown(1) then
		player.applyForce(2,math.pi/6)
	end
	
	if love.mouse.isDown(2) then
		player.velocity = player.velocity + 2
		player.boosting = 1
	else
		player.boosting = 0
	end

	if love.mouse.isDown(3) then
		player.velocity = 0
	end

end






function player.move(dt)
	
	--This ensures x and y vel are related to direction and velocity, even though the operations happen on them. 
	--That way angle or velocity can be changed externally and prouce accurate results.
	player.yVelocity = math.sin(player.direction)*player.velocity 
    player.xVelocity = math.cos(player.direction)*player.velocity
	
	--Regular directions
	
	if love.keyboard.isDown('w') then
		player.yVelocity = player.yVelocity-player.acceleration
	end
	
	if love.keyboard.isDown('a') then
		player.xVelocity = player.xVelocity-player.acceleration
	end
	
	if love.keyboard.isDown('s') then
		player.yVelocity = player.yVelocity+player.acceleration
	end
	
	if love.keyboard.isDown('d') then
		player.xVelocity = player.xVelocity+player.acceleration
	end
	
	player.materializeVelocityAndDirection()
	
	player.velocity = player.velocity - player.traction --obv
	
	if player.velocity > player.maxSpeed and player.boosting == 0 then --obv
		player.velocity = player.maxSpeed
	end
	
	if player.velocity <= 0 then 
		--Player.moving was a variable from the top-down base I used, so I just kept it. This actually prevent friction from moving you backwards.
		player.velocity = 0
		player.moving = false
	else
		player.moving = true
	end
	
	
	
	--This is called here again for calculations sake / making sure maxspeed and friction are applied. 
	--It needs to be called up front too so that external operations can affect it.
	--Actually I think it would be better to have a function alterPlayerMovement and put all the operations in there and call it here
	player.alterMovement()
	player.yVelocity = math.sin(player.direction)*player.velocity 
    player.xVelocity = math.cos(player.direction)*player.velocity
	
	player.x = player.x + player.xVelocity
	player.y = player.y + player.yVelocity
	
	print(player.velocity, player.yVelocity, player.xVelocity, player.direction)
end




function player.draw()
	
	--Draw player
	love.graphics.setColor(255, 255, 0)
	love.graphics.push()
	love.graphics.translate(player.x, player.y)
	love.graphics.rotate(player.direction+math.pi/2)
	love.graphics.translate(-player.x, -player.y)
	love.graphics.polygon('fill', player.x, player.y-25, player.x-20, player.y+25, player.x+20, player.y+25)
	love.graphics.pop()
	
	--Draw health
	love.graphics.setColor(255, 0, 0)
	for i=1,player.health do
		love.graphics.rectangle('fill', i*50-30, 20, 30, 30)
	end
	
end






function player.materializeVelocityAndDirection()
	if player.xVelocity ~= 0 then --0 in denominator
		player.direction = math.atan(player.yVelocity/player.xVelocity)
	 end

	if player.xVelocity < 0 and player.yVelocity>0 or player.xVelocity < 0 and player.yVelocity<0 or player.xVelocity > 0 and player.yVelocity<0 then 
		--adjust for quadrant. Unfortunately there's no other workaround for atan
		player.direction = player.direction + math.pi
		if player.xVelocity > 0 and player.yVelocity<0 then
			player.direction = player.direction + math.pi
		end
	end


	if player.yVelocity == 0 and player.xVelocity == -player.acceleration then 
		--special case where since the direction can't update, since xVelocity is 0, it, thinks it's moving forward (angle 0) instead of backward (angle pi)
		player.direction = math.pi
	end


	player.velocity = math.sqrt(player.yVelocity^2 + player.xVelocity^2)
end



function player.applyForce(magnitude, direction)
	local y = math.sin(direction)*magnitude
	local x = math.cos(direction)*magnitude

	player.yVelocity = math.sin(player.direction)*player.velocity + y
	player.xVelocity = math.cos(player.direction)*player.velocity + x

	player.materializeVelocityAndDirection() 
	--Calling this here is necessary, but inefficient, and this could all be integrated better.
	--I daresay it isn't too costly, and having the versitility to call it like this is better.
	--This way, you can always apply directly to magnitude and direction, which should be regarded as the 'actual' and xVelocity and yVelocity as the temporary means to those ends.
	--You'll have to call it a lot, but it removes the semantic tediousness of getting all the functions in the right order.
end