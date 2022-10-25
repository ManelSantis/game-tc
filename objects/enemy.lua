local love = require "love"
function Enemy(level, _world, _size)
    local dice = math.random(1, 4)
    local _x, _y

    local function distanceFrom(x1, y1, x2, y2)
        return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2) 
    end

    if dice == 1 then -- come from above --
        _x = math.random(_size, love.graphics.getWidth())
        _y = -_size * 4
    elseif dice == 2 then -- come from the left --
        _x = -_size * 4
        _y = math.random(_size, love.graphics.getHeight())
    elseif dice == 3 then -- come from the bottom --
        _x = math.random(_size, love.graphics.getWidth())
        _y = love.graphics.getHeight() + (_size * 4)
    else -- come from the right --
        _x = love.graphics.getWidth() + (_size * 4)
        _y = math.random(_size, love.graphics.getHeight())
    end

    return {
        level = level,
        x = _x,
        y = _y,
        size = _size,
        world = _world,
        body,
        shape,
        fixture,
        createEnemy = function(self)
            self.body = love.physics.newBody (self.world, self.x, self.y, "dynamic")
            self.shape = love.physics.newCircleShape(self.size)
            self.fixture = love.physics.newFixture(self.body, self.shape, 1)
            return self.body, self.shape, self.fixture      
        end,
        
        checkTouched = function (self, player_x, player_y, cursor_radius) -- collision detection with the player
            -- below will detect if the enemy is anywhere near the player
            return math.sqrt((self.x - player_x) ^ 2 + (self.y - player_y) ^ 2) <= cursor_radius * 2
        end,

        moveEnemy = function (self, player_x, player_y)

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

        end,
        color = function (self)
            love.graphics.setColor(1, 0.5, 0.7)
        end
    }
end

return Enemy