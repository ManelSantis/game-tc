local love = require("love")
local vel = require("./libraries/Vector")


function Munition(mouseX, mouseY, initX, initY, _world)

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
        size = 10,
        inScreen = true,
        world = _world,
        body,
        shape,
        fixture,
        createMunition = function (self)
            self.body = love.physics.newBody (self.world, self.x, self.y, "dynamic")
            self.shape = love.physics.newCircleShape(self.size)
            self.fixture = love.physics.newFixture(self.body, self.shape, 1)
            return self.body, self.shape, self.fixture         
        end,
        moveMunition = function (self, dt)
            self.x = self.x + (self.dx * dt)
            self.y = self.y + (self.dy * dt)
            self.body:setX(self.x)
            self.body:setY(self.y)
        end,
        color = function (self)
            love.graphics.setColor(1, 0, 0)
        end
    }

end

return Munition