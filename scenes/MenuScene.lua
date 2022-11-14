local MenuScene = {}


function MenuScene:load()
	self.background = love.graphics.newImage("img/capa.png")
	self.musicMenus = love.audio.newSource("audio/Fat Man - Yung Logos.mp3", "stream")
	love.audio.play( self.musicMenus )
	
end

function MenuScene:update(dt)
	
	
	--self.test = dt
end

function MenuScene:draw()
	for i = 0, love.graphics.getWidth() / self.background:getWidth() do
        for j = 0, love.graphics.getHeight() / self.background:getHeight() do
            love.graphics.draw(self.background, i * self.background:getWidth(), j * self.background:getHeight())
        end
    end
	--love.graphics.print(self.test)
end
function MenuScene:keypressed(key, scancode, isrepeat)
	
	
	if key=="escape" then
		love.event.quit() --quit the game
	elseif key=="space" then
		self.musicMenus:stop();
		score = 0
		changeScene("GameScene") --switch to Scene2
	end

end


-- return the table containing all the functions defined above
return MenuScene