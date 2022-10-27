local Enemy = {}

function Enemy:load(_level, _size)
    local dice = math.random(1, 4)
    local _x, _y

    if dice == 1 then --Enemy come from above
        _x = math.random(_size, love.graphics.getWidth())
        _y = -_size * 4
    elseif dice == 2 then --Enemy come from the left
        _x = -_size * 4
        _y = math.random(_size, love.graphics.getHeight())
    elseif dice == 3 then --Enemy come from the bottom
        _x = math.random(_size, love.graphics.getWidth())
        _y = love.graphics.getHeight() + (_size * 4)
    else --Enemy come from the right
        _x = love.graphics.getWidth() + (_size * 4)
        _y = math.random(_size, love.graphics.getHeight())
    end

    self.x = _x
    self.y = _y
    self.level = _level
    self.size = _size

    self.body = love.physics.newBody (World, self.x, self.y, "dynamic")
    self.body:setMass(10)
    self.shape = love.physics.newCircleShape(self.size)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)
           
    self.type = "enemy"
end

function Enemy:update(dt, player_x, player_y)
    self:move(dt, player_x, player_y)
end

function Enemy:move(dt, player_x, player_y)
    --[[
    if player_x - self.x > 0 then
        self.x = self.x + self.level
    elseif player_x - self.x < 0 then
        self.x = self.x - self.level
    end
 
    if player_y - self.y > 0 then
        self.y = self.y + self.level
    elseif player_y - self.y < 0 then
        self.y = self.y - self.level
    end
    --self.body:setY(self.y)
    --self.body:setX(self.x)
    local angle = math.deg(math.atan2(self.body:getY() - player_y, self.body:getX() - player_x))

    if angle > 0 then
        angle =  -(angle - 180)
    else
        angle  = (-angle) + 180
    end

    local dx = math.cos(angle)
    local dy = math.sin(angle)

    if angle >=0 and angle <=90 then
        dx = 200 * dt
        dy = -200 * dt
    end

    if angle <= 360 and angle >= 270 then
        dx = 200 * dt
        dy = 200 * dt
    end 

    if angle <=270 and angle >=180 then
        dx = -200 * dt
        dy = -200 * dt
    end

    if angle <=180 and angle >=90 then
        dx = -200 * dt
        dy = 200 * dt
    end


    --[[if angle > 0 then
        angle =  -(angle - 180)
        self.body:applyForce(-math.cos(angle), math.sin(angle))
    else
        angle  = (-angle) + 180 
        self.body:applyForce(-math.cos(angle), math.sin(angle))
    end]]

    local distance = self:distance(player_x, player_y)

    local dx = player_x - self.body:getX()
    local dy = player_y - self.body:getY()

    self.x = self.x + dx / distance * 200 * dt
    self.y = self.y + dy / distance * 200 * dt

    self.body:setPosition(self.x, self.y)
end

function Enemy:beginContact(a, b, collision)

end

function Enemy:distance (player_x, player_y)
    return math.sqrt((self.x - player_x) ^ 2 + (self.y - player_y) ^ 2)
end

function DistanceFrom(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2) 
end

function Enemy:endContact(a, b, collision)

end

function Enemy:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.size)
    --[[love.graphics.print(ANGLE, self.body:getX(), self.body:getY()+ 70)
    love.graphics.print(DX, self.body:getX(), self.body:getY()+ 100)
    love.graphics.print(DY, self.body:getX(), self.body:getY()+ 120)]]
end

return Enemy