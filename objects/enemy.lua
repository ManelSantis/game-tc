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
    self.shape = love.physics.newCircleShape(self.size)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)
           
    self.type = "enemy"
end

function Enemy:update(dt, player_x, player_y)
    self:move(dt, player_x, player_y)
end

function Enemy:move(dt, player_x, player_y)
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
    
    self.body:setX(self.x)
    self.body:setY(self.y)
end

function Enemy:beginContact(a, b, collision)

end

function Enemy:checkTouched (player_x, player_y, cursor_radius) -- collision detection with the player
    -- below will detect if the enemy is anywhere near the player
    return math.sqrt((self.x - player_x) ^ 2 + (self.y - player_y) ^ 2) <= cursor_radius * 2
end

function DistanceFrom(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2) 
end

function Enemy:endContact(a, b, collision)

end

function Enemy:draw()
    love.graphics.setColor(1, 0.5, 0.7)
    love.graphics.circle("fill", self.x, self.y, self.size)
end

return Enemy