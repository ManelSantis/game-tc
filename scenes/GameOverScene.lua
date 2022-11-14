local GameOverScene = {}

function GameOverScene:load()
	self.background = love.graphics.newImage("img/lost.png")
	self.musicMenus = love.audio.newSource("audio/Fat Man - Yung Logos.mp3", "stream")
	love.audio.play( self.musicMenus )
end

function GameOverScene:update(dt)
	-- nothing here yet
end

function GameOverScene:draw()
	for i = 0, love.graphics.getWidth() / self.background:getWidth() do
        for j = 0, love.graphics.getHeight() / self.background:getHeight() do
            love.graphics.draw(self.background, i * self.background:getWidth(), j * self.background:getHeight())
        end
    end
	love.graphics.print('Memory actually used (in kB): ' .. collectgarbage('count'), 10,10)
	love.graphics.setNewFont(20)
	love.graphics.printf(score, 600, 500, 100, 'center')
end
function GameOverScene:keypressed(key, scancode, isrepeat)
	
	
	if key=="escape" then
		love.event.quit() --quit the game
	elseif key=="return" then
		self.musicMenus:stop();
		changeScene("MenuScene") --switch to Scene2
	end
	
end


-- return the table containing all the functions defined above
return GameOverScene