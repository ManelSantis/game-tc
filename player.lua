local love = require "love"

function Player(debugging)
    local player_size = 30 --radius
    local player_x = 400 --initial X
    local player_y = 350 --initial Y
    local speed = 5

    debugging = debugging or false

    return {
        x = player_x,
        y = player_y,
        size = player_size,
        draw = function (self)
            love.graphics.setColor(248 / 255, 255 / 255, 1 / 255)
            love.graphics.circle("fill", self.x, self.y, self.size)
        end,

        movePlayer = function (self)

            if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
                self.x = self.x + speed
            end

            if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
                self.x = self.x - speed
            end

            if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
                self.y = self.y + speed
            end

            if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
                self.y = self.y - speed
            end
        end

    }

end

return Player