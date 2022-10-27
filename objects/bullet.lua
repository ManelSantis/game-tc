local Bullet = {}
local Bullets =  {}

Bullet.__index = Bullet

function Bullet:load()
    
end

function Bullet:addBullet(mouseX, mouseY, initX, initY)
    local instance = setmetatable({}, Bullet)
    instance.speed = 250

    --[[local w = initX
    local h = initY
    
    local deltaX = mouseX - w 
    local deltaY = mouseY - h 
   
    instance.o_angle = math.atan2(deltaY, deltaX)
    instance.o_angle = -math.deg(instance.o_angle)

    instance.dx = instance.speed * math.cos(instance.o_angle)
    instance.dy = instance.speed * math.sin(instance.o_angle)]]
    
    instance.mouseX = mouseX
    instance.mouseY = mouseY
    instance.x = initX
    instance.y = initY
    instance.onScreen = true
    instance.size = 10

    instance.body = love.physics.newBody (World, instance.x, instance.y, "dynamic")
    instance.shape = love.physics.newCircleShape(instance.size)
    instance.fixture = love.physics.newFixture(instance.body, instance.shape, 1)

    table.insert(Bullets, instance)
end

function Bullet:distance(mouseX, mouseY, bx, by)
    return math.sqrt((bx - mouseX) ^ 2 + (by - mouseY) ^ 2)
end

function Bullet:update(dt)
    self:moveBullet(dt)
end


function Bullet.updateAll(dt)
    for i,instance in ipairs(Bullets) do
        instance:update(dt)
    end
end

function Bullet:moveBullet(dt)

    local dx = self.mouseX - self.x
    local dy = self.mouseY - self.y
    
    local d = self:distance(self.mouseX, self.mouseY, self.x, self.y)
    self.x = self.x + dx / d * self.speed * dt
    self.y = self.y + dy / d * self.speed * dt
    self.body:setPosition(self.x, self.y)

    
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