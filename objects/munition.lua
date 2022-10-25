local love = require("love")
local vel = require("./libraries/Vector")


function Munition(mouseX, mouseY, initX, initY)

    local speed = 250

    local w = initX
    local h = initY
    
    local deltaX = mouseX - w 
    local deltaY = mouseY - h 
   
    local o_angle = math.atan2(deltaY, deltaX)
    o_angle = -math.deg(o_angle)
    --o_angle = (o_angle*math.pi)/360
    --vel = Vector(o_angle, o_mag)

    return {
        dx = speed * math.cos(o_angle),
        dy = speed * math.sin(o_angle),
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