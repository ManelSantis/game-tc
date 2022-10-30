local Enemy = require("objects/enemy")

local Laser = {}
local Lasers =  {}

Laser.__index = Laser

function Laser:load()
    _G.SW, _G.SH = 80, 20
    _G.QW = 20
    _G.QH = SH
end

function Laser:addLaser(mouseX, mouseY, initX, initY)
    local instance = setmetatable({}, Laser)

    instance.sprite = love.graphics.newImage("img/laser_tile.png")
    instance.animation = {
            frame = 1,
            max_frames = 4,
            speed = 10,
            timer = 0.3
    }

    instance.initTimer = love.timer.getTime()
    
    local deltaX = initX - mouseX
    local deltaY = initY - mouseY
    
    instance.o_angle = math.atan2(deltaY, deltaX)
    --instance.o_angle = math.deg(instance.o_angle)

    instance.dx = mouseX + (900 * -math.cos(instance.o_angle))
    instance.dy = mouseY + (900 * -math.sin(instance.o_angle))

    instance.x = initX + (90 * -math.cos(instance.o_angle))
    instance.y = initY + (90 * -math.sin(instance.o_angle))
    instance.onScreen = true
    instance.size = 5

    instance.body = love.physics.newBody (World, instance.x, instance.y, "dynamic")
    instance.shape = love.physics.newEdgeShape(instance.x, instance.y, instance.dx, instance.dy)
    instance.fixture = love.physics.newFixture(instance.body, instance.shape, 1)
    instance.tableX, instance.tableY = instance:pointsBetween()

    instance.quads = {}

    for i = 1, instance.animation.max_frames do
        instance.quads[i] = love.graphics.newQuad(QW * (i-1), 0, QW, QH, SW, SH)
    end

    table.insert(Lasers, instance)
end

function Laser:update(dt, i, enemies)
    --self:moveLaser(dt, i, enemies)
    self:animate(dt)
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

function Laser:animate(dt)
    self.animation.timer = self.animation.timer + dt

    if self.animation.timer > 0.00001 then
        self.animation.timer = 0.1
        self.animation.frame = self.animation.frame + 1

        if(self.animation.frame > self.animation.max_frames) then
            self.animation.frame = 1
        end
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
    --love.graphics.line(self.x, self.y, self.dx, self.dy)
    local r = math.random(0, 255)
    local g = math.random(0, 255)
    local b = math.random(0, 255)
    love.graphics.setColor(r / 255, g / 255, b / 255)

    for i= 1, #self.tableX do
        love.graphics.draw(self.sprite, self.quads[self.animation.frame], self.tableX[i] - QW / 2, self.tableY[i] - QH / 2)
    end

    love.graphics.setColor(1, 1, 1)

end

return Laser