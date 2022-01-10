player = {}

function player.load( ... )
	--Player Definitions: starts in center
	player.x = love.graphics.getWidth() / 2
	player.y = love.graphics.getHeight() / 2
	player.speed = 5
	player.direction = 0
	player.health = 5
	player.moving = false

end




function player.update(dt)
 
--Movement
	player.moving = false

--Special directions
	if love.keyboard.isDown('w') and love.keyboard.isDown('a') then
		player.direction = math.pi*1.75
		player.x=player.x-(player.speed/1.5)
		player.y=player.y-(player.speed/1.5)
		player.moving = true
	end

	if love.keyboard.isDown('w') and love.keyboard.isDown('d') and player.moving==false then
		player.direction = math.pi*0.25
		player.x=player.x+(player.speed/1.5)
		player.y=player.y-(player.speed/1.5)
		player.moving = true
	end

	if love.keyboard.isDown('s') and love.keyboard.isDown('a') and player.moving==false then
		player.direction = math.pi*1.25
		player.x=player.x-(player.speed/1.5)
		player.y=player.y+(player.speed/1.5)
		player.moving = true
	end

	if love.keyboard.isDown('s') and love.keyboard.isDown('d') and player.moving==false then
		player.direction = math.pi*0.75
		player.x=player.x+(player.speed/1.5)
		player.y=player.y+(player.speed/1.5)
		player.moving = true
	end

--Regular directions
	if love.keyboard.isDown('w') and player.moving==false then
		player.y = player.y-player.speed
		player.direction = 0
		player.moving = true
	end

	if love.keyboard.isDown('a') and player.moving==false then
		player.x = player.x-player.speed
		player.direction = 1.5*math.pi
		player.moving = true
	end

	if love.keyboard.isDown('s') and player.moving==false then
		player.y = player.y+player.speed
		player.direction = math.pi
		player.moving = true
	end

	if love.keyboard.isDown('d') and player.moving==false then
		player.x = player.x+player.speed
		player.direction = math.pi/2
		player.moving = true
	end

end




function player.draw()

--Draw player
	love.graphics.setColor(255, 255, 0)
	love.graphics.push()
	love.graphics.translate(player.x, player.y)
	love.graphics.rotate(player.direction)
	love.graphics.translate(-player.x, -player.y)
	love.graphics.polygon('fill', player.x, player.y-25, player.x-20, player.y+25, player.x+20, player.y+25)
	love.graphics.pop()

	--Draw health
	love.graphics.setColor(255, 0, 0)
	for i=1,player.health do
		love.graphics.rectangle('fill', i*50-30, 20, 30, 30)
	end

end

