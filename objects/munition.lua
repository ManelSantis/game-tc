local love = require("love")
local vel = require("./libraries/Vector")


function Munition(mouseX, mouseY, initX, initY)

    local o_mag = math.sqrt(mouseX^2 + mouseY^2)
    local o_angle = 0
    local PI = math.pi

    local w = initX
    local h = initY
    
    local deltaX = mouseX - w
    local deltaY = mouseY - h
    o_angle = math.atan2(deltaY, deltaX)

    --local rad = math.atan2(deltaY, deltaX)
    --o_angle = rad * (360 / PI)

    --vel = Vector(o_angle, o_mag)

    return {
        dx = 250 * math.cos(o_angle),
        dy = 250 * math.sin(o_angle),
        x = initX,
        y = initY,
        inScreen = true,
        draw = function (self)
            love.graphics.circle("line", self.x , self.y , 10)
        end,
        moveMunition = function (self, dt)
            self.x = self.x + (self.dx * dt)
            self.y = self.y + (self.dy * dt)
        end
    }

end

return Munition