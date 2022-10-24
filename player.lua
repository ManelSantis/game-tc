local love = require "love"

function Player(debugging, limite_x, limite_y)
    local player_size = 30 --radius
    local player_x = limite_x / 2 --initial X
    local player_y = limite_y / 2 --initial Y
    local speedX = 5
    local speedY = 5

    debugging = debugging or false

    return {
        x = player_x,
        y = player_y,
        size = player_size,
        lx = limite_x,
        ly = limite_y,
        draw = function (self)
            love.graphics.setColor(248 / 255, 255 / 255, 1 / 255)
            love.graphics.circle("fill", self.x, self.y, self.size)
        end,

        movePlayer = function (self)

            if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
                if self.x < (self.lx - self.size) then
                    self.x = self.x + speedX
                end
            end

            if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
                if self.x > (0 + self.size) then
                    self.x = self.x - speedX
                end
            end

            if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
                if self.y < (self.ly - self.size) then
                    self.y = self.y + speedY
                end
            end

            if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
                if self.y > (0 + self.size) then
                    self.y = self.y - speedY
                end
            end
        end

    }

end

return Player