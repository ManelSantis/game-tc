local Enemy = require("objects/enemy")

local Bullet = {}
local Bullets =  {}

Bullet.__index = Bullet

function Bullet:load(limit_x, limit_y)
    _G.LimitX = limit_x
    _G.LimitY = limit_y

    _G.SW, _G.SH = 80, 20
    _G.QW = 20
    _G.QH = SH
end

function Bullet:addBullet(mouseX, mouseY, initX, initY)
    local instance = setmetatable({}, Bullet)

    instance.sprite = love.graphics.newImage("img/bullet_tile.png")
    instance.animation = {
            frame = 1,
            max_frames = 4,
            speed = 20,
            timer = 0.3
    }

    instance.speed = 700
    
    local deltaX = initX - mouseX
    local deltaY = initY - mouseY
   
    instance.o_angle = math.atan2(deltaY, deltaX)
    --instance.o_angle = math.deg(instance.o_angle)

    instance.dx = -math.cos(instance.o_angle)
    instance.dy = -math.sin(instance.o_angle)
    
    instance.mouseX = mouseX
    instance.mouseY = mouseY
    instance.x = initX + (90 * -math.cos(instance.o_angle))
    instance.y = initY + (90 * -math.sin(instance.o_angle))
    instance.onScreen = true
    instance.size = 5

    instance.body = love.physics.newBody (World, instance.x, instance.y, "dynamic")
    instance.shape = love.physics.newCircleShape(instance.size)
    instance.fixture = love.physics.newFixture(instance.body, instance.shape, 1)

    instance.quads = {}

    for i = 1, instance.animation.max_frames do
        instance.quads[i] = love.graphics.newQuad(QW * (i-1), 0, QW, QH, SW, SH)
    end

    table.insert(Bullets, instance)
end

function Bullet:update(dt, i, enemies)
    self:moveBullet(dt, enemies)

    self:removeBullet(i, self.onScreen)

end


function Bullet.updateAll(dt, enemies)
    for i,instance in ipairs(Bullets) do
        instance:update(dt, i, enemies)
    end
end

function Bullet:animate(dt)
    self.animation.timer = self.animation.timer + dt

    if self.animation.timer > 0.2 then
        self.animation.timer = 0.1
        self.animation.frame = self.animation.frame + 1

        if(self.animation.frame > self.animation.max_frames) then
            self.animation.frame = 1
        end
    end
end

function Bullet:moveBullet(dt, enemies)

    --local dx = self.mouseX - self.x
    --local dy = self.mouseY - self.y
    --local d = self:distance(self.mouseX, self.mouseY, self.x, self.y)
    
    self.x = self.x + self.dx * self.speed * dt
    self.y = self.y + self.dy * self.speed * dt
    self.body:applyForce(self.x, self.y)

    if self.x >= LimitX or self.x <= 0 then
        self.onScreen = false
    end

    if self.y >= LimitY or self.y <= 0 then
        self.onScreen = false
    end

    self:touchEnemies(enemies)
    self:animate(dt)

end

function Bullet:touchEnemies(enemies)
    for i, instance in ipairs(enemies) do
        local distance = self:distance(instance.body:getX(), instance.body:getY())
        if distance <= instance.size then
            self.onScreen = false
            instance.onScreen = false
            return
        end
    end
end

function Bullet:distance (x, y)
    return math.sqrt((self.x - x) ^ 2 + (self.y - y) ^ 2)
end


function Bullet:removeBullet(index, onScreen)
    if onScreen == false then
        table.remove(Bullets, index)
    end
end

function Bullet.drawAll()
    for i,instance in ipairs(Bullets) do
        instance:draw()
    end
end

function Bullet:draw()

    local r = math.random(110, 255)
    local g = math.random(110, 255)
    local b = math.random(110, 255)
    love.graphics.setColor(r / 255, g / 255, b / 255)
    --love.graphics.circle("line", self.x, self.y, self.size)
    love.graphics.draw(self.sprite, self.quads[self.animation.frame], self.x - QW / 2, self.y - QH / 2)

    love.graphics.setColor(1, 1, 1)

end

return Bullet