local love = require "love"

function Player(limit_x, limit_y, _world, _size, speedX, speedY)

    return {
        x = limit_x / 2,
        y = limit_y / 2,
        lx = limit_x,
        ly = limit_y,
        size = _size,
        world = _world,
        body,
        shape,
        fixture,
        createPlayer = function (self)
            self.body = love.physics.newBody (self.world, self.x, self.y, "dynamic")
            self.shape = love.physics.newCircleShape(self.size)
            self.fixture = love.physics.newFixture(self.body, self.shape, 1)
            return self.body, self.shape, self.fixture            
        end,
        movePlayer = function (self, dt)
            if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
                if self.x < (self.lx - self.size) then
                    self.x = self.x + speedX * dt
                    self.body:setX(self.x)
                end
            end

            if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
                if self.x > (0 + self.size) then
                    self.x = self.x - speedX * dt
                end
            end

            if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
                if self.y < (self.ly - self.size) then
                    self.y = self.y + speedY * dt
                end
            end

            if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
                if self.y > (0 + self.size) then
                    self.y = self.y - speedY * dt
                end
            end   
            
            self.body:setX(self.x)
            self.body:setY(self.y)

        end,
        color = function (self)
            love.graphics.setColor(248 / 255, 255 / 255, 1 / 255)
        end

    }

end

return Player