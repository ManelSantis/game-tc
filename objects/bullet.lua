local Enemy = require("objects/enemy")

local Bullet = {}
local Bullets =  {}

Bullet.__index = Bullet

function Bullet:load(limit_x, limit_y)
    _G.LimitX = limit_x
    _G.LimitY = limit_y

    

end

function Bullet:addBullet(mouseX, mouseY, initX, initY)
    local instance = setmetatable({}, Bullet)
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

    table.insert(Bullets, instance)
end

function Bullet:update(dt, i, enemies)
    self:moveBullet(dt, i, enemies)
end


function Bullet.updateAll(dt, enemies)
    for i,instance in ipairs(Bullets) do
        instance:update(dt, i, enemies)
    end
end

function Bullet:moveBullet(dt, i, enemies)

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

    self:removeBullet(i, self.onScreen)

end

function Bullet:touchEnemies(enemies)
    for i, instance in ipairs(enemies) do
        local distance = self:distance(instance.body:getX(), instance.body:getY())
        if distance < instance.size + instance.size then
            self.onScreen = false
            instance.onScreen = false
            return
        end
    end
end

function Bullet.beginContact(a, b, collision)
    for i,instance in ipairs(Bullets) do
        for i, enemies in ipairs (Enemy:activeEnemies()) do
            if a == instance.fixture or b == instance.fixture then
                if a == enemies.fixture or b == enemies.fixture then
                   enemies.onScreen = false
                   instance.onScreen = false
                end
             end
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
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("line", self.x, self.y, self.size)
end

return Bullet