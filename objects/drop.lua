local Drop = {}
local Drops = {}

Drop.__index = Drop

function Drop:load()

end

function Drop:addDrop(posX, posY, type)
    local instance = setmetatable({}, Drop)

    instance.x = posX
    instance.y = posY
    instance.type = type
    instance.size = 10
    instance.initTimer = love.timer.getTime()

    instance.body = love.physics.newBody (World, instance.x, instance.y, "dynamic")
    instance.shape = love.physics.newCircleShape(instance.size)
    instance.fixture = love.physics.newFixture(instance.body, instance.shape, 1)

    instance.onScreen = true
    instance.touchedPlayer = false

    table.insert(Drops, instance)
end

function Drop:update(dt, playerX, playerY, i)
    local test = self:distance(playerX, playerY)

    if test == true then
        self.onScreen = false
        self.touchedPlayer = true
    end

    local timePassed = (love.timer.getTime() - self.initTimer) * 1000
    if timePassed >= 10000 then
        self.onScreen = false
    end

    if self.onScreen == false then
        self:removeDrop(i)
    end
end

function Drop:distance (playerX, playerY)

    local auxX = math.abs(self.x - playerX)
    local auxY = math.abs(self.y - playerY)

    if (auxX > (60 / 2 + self.size)) then
        return false
    end 

    if (auxY > (120 / 2 + self.size)) then
        return false
    end

    if (auxX <= (60 / 2)) then
        return true
    end
    
    if (auxY <= (120 / 2)) then
        return true
    end

    local cornerDistance_sq = (auxX - 60 / 2)^2 + (auxY - 120 / 2)^2;

    return (cornerDistance_sq <= (self.size^2));
end

function Drop:removeDrop(index)
    if self.touchedPlayer == true then
        if self.type == 1 then 
            LASER = true
            LASER_TIMER = love.timer.getTime()
            END_LASER = 0
        end

        if self.type == 2 then 
            SLOW = true
            SLOW_TIMER = love.timer.getTime()
            END_SLOW = 0
        end

        if self.type == 3 then 
            SPEED = true
            SPEED_TIMER = love.timer.getTime()
            END_SPEED = 0
        end

        if self.type == 4 then 
            INVENSIBLE = true
            INVENSIBLE_TIMER = love.timer.getTime()
            END_INVENSIBLE = 0
        end

        if self.type == 5 then
            --CODE FOR LIFE
        end
    end
    table.remove(Drops, index)
end

function Drop.updateAll(dt, playerX, playerY)
    for i, instance in ipairs(Drops) do
        instance:update(dt, playerX, playerY, i)
    end
end

function Drop.drawAll()
    for i, instance in ipairs(Drops) do
        instance:draw()
    end
end

function Drop:draw()
    if self.type == 1 then
        love.graphics.setColor(12/255, 12/255, 121/255) --Laser
    end

    if self.type == 2 then
        love.graphics.setColor(179/255, 251/255, 248/255) --Slow
    end

    if self.type == 3 then
        love.graphics.setColor(50/255, 242/255, 2/255) --Speed
    end

    if self.type == 4 then
        love.graphics.setColor(234/255, 240/255, 4/255) --Invensible
    end

    if self.type == 5 then
        love.graphics.setColor(244/255, 0, 0) --Life
    end

    love.graphics.circle("fill", self.x, self.y, self.size)
    love.graphics.setColor(1,1,1)
end

return Drop