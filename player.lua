local Player = {}

function Player:load(limit_x, limit_y, _size, speedX, speedY)
    self.x = limit_x / 2
    self.y = limit_y / 2
    self.lx = limit_x
    self.ly = limit_y
    self.size = _size
    self.velX = speedX
    self.velY = speedY

    self.body = love.physics.newBody (World, self.x, self.y, "dynamic")
    self.shape = love.physics.newCircleShape(self.size)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)

    self.type = "player"
end

function Player:update(dt)
    self:move(dt)
end

function Player:move(dt)
    if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        if self.x < (self.lx - self.size - 10) then
            self.x = self.x + self.velX * dt
        end
    end

    if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
        if self.x > (0 + self.size + 10) then
            self.x = self.x - self.velX * dt
        end
    end

    if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
        if self.y < (self.ly - self.size - 10) then
            self.y = self.y + self.velY * dt
        end
    end

    if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
        if self.y > (0 + self.size + 10) then
            self.y = self.y - self.velY * dt
        end
    end   

    self.body:setPosition(self.x, self.y)
end

function Player:beginContact(a, b, collision)

end

function Player:endContact(a, b, collision)

end

function Player:draw()
    love.graphics.setColor(248 / 255, 255 / 255, 1 / 255)
    love.graphics.circle("fill", self.x, self.y, self.size)

end

return Player