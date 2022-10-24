local love = require("love")


function Munition(mouseX, mouseY, initX, initY)

    local o_mag = math.sqrt(mouseX^2 + mouseY^2)
    local o_angle = 0
    local PI = math.pi
    local gameTime = love.timer.getFPS()

    local w = initX / 2
    local h = initY / 2
    
    local deltaX = w - mouseX
    local deltaY = h - mouseY
    
    local rad = math.atan(deltaX, deltaY)
    o_angle = rad * (360 / PI)

    while (o_angle < 0 or o_angle > 360) do
        if o_angle >= 360 then
            o_angle = o_angle - 360
        else
            o_angle = o_angle + 360
        end
    end 

    return {
        dx = o_mag * math.cos(o_angle),
        dy = o_mag * math.sin(o_angle),
        x = initX,
        y = initY,
        inScreen = true,
        draw = function (self)
            love.graphics.circle("line", self.x , self.y , 10)
        end,
        moveMunition = function (self)
            self.x = self.x + (self.dx * 0.002)
            self.y = self.y + (self.dy * 0.002)
            --self.x = self.x + (self.dx * 0.002)
            --self.y = self.y + (self.dy * 0.002)
        end
    }

    
end

return Munition