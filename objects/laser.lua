local Enemy = require("objects/enemy")

local Laser = {}
local Lasers =  {}

Laser.__index = Laser

function Laser:load()

end

function Laser:addLaser(mouseX, mouseY, initX, initY)
    local instance = setmetatable({}, Laser)
    instance.initTimer = love.timer.getTime()
    
    local deltaX = initX - mouseX
    local deltaY = initY - mouseY
    
    instance.o_angle = math.atan2(deltaY, deltaX)
    --instance.o_angle = math.deg(instance.o_angle)

    instance.dx = mouseX + (500 * -math.cos(instance.o_angle))
    instance.dy = mouseY + (500 * -math.sin(instance.o_angle))

    instance.x = initX + (90 * -math.cos(instance.o_angle))
    instance.y = initY + (90 * -math.sin(instance.o_angle))
    instance.onScreen = true
    instance.size = 5

    instance.body = love.physics.newBody (World, instance.x, instance.y, "dynamic")
    instance.shape = love.physics.newEdgeShape(instance.x, instance.y, instance.dx, instance.dy)
    instance.fixture = love.physics.newFixture(instance.body, instance.shape, 1)
    instance.tableX, instance.tableY = instance:pointsBetween()
    table.insert(Lasers, instance)
end

function Laser:update(dt, i, enemies)
    --self:moveLaser(dt, i, enemies)

    self:touchEnemies(enemies)

    local timePassed = (love.timer.getTime() - self.initTimer) * 1000
    if timePassed >= 350 then
        self.onScreen = false
    end

    self:removeLaser(i, self.onScreen)
end

function Laser:pointsBetween()
    local tableX = {}
    local tableY = {}
    local diffX = self.x - self.dx
    local diffY = self.y - self.dy
    local x, y
    local quant = 200
        for i=1, quant, 1 do
            x = diffX / quant * i + self.dx
            y = diffY / quant * i + self.dy
            table.insert(tableX, x)
            table.insert(tableY, y)
        end
    return tableX, tableY
end

function Laser.updateAll(dt, enemies)
    for i,instance in ipairs(Lasers) do
        instance:update(dt, i, enemies)
    end
end

function Laser:touchEnemies(enemies)
    for i, instance in ipairs(enemies) do
        for j=1, #self.tableX do
            local help = self:distance(self.tableX[j], self.tableY[j], instance.x, instance.y, instance.size)
            if help == true then
                self.onScreen = false
                instance.onScreen = false
            end
        end
    end
end

function Laser:distance (x1, y1, x2, y2, rad)
    local deltaX = x1 - x2
    local deltaY = y1 - y2
    return math.sqrt(deltaX*deltaX + deltaY*deltaY) <= rad
end

function Laser:removeLaser(index, onScreen)
    if onScreen == false then
        table.remove(Lasers, index)
    end
end

function Laser.drawAll()
    for i,instance in ipairs(Lasers) do
        instance:draw()
    end
end

function Laser:draw()
    love.graphics.line(self.x, self.y, self.dx, self.dy)

    --[[for i= 1, #self.tableX do
        love.graphics.circle("line", self.tableX[i], self.tableY[i], 5)
    end]]
end

return Laser