require 'player'


function love.load( ... )
	player.load()
end


function love.update(dt)
 
--Quit
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end

--Update Player
	player.update()
end


function love.draw( )
	player.draw()

end

