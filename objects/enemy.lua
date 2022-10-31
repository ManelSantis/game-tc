local Enemy = {}
local Enemies = {}

Enemy.__index = Enemy

function Enemy:load()    
end

function Enemy:addEnemy(_level, _size)
    local instance = setmetatable({}, Enemy)
    local dice = math.random(1, 4)
    local _x, _y
    instance.sprite = love.graphics.newImage("img/alien_bigger.png")
    instance.animation = {
            direction = "right",
            idle = false,
            frame = 1,
            max_frames = 4,
            speed = 20,
            timer = 0.3
    }
    SPRITE_WIDTH, SPRITE_HEIGH = 264, 94
    QUAD_WIDTH = 66
    QUAD_HEIGH = SPRITE_HEIGH
    instance.touthPLayer = false;

    instance.life = 100

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

    instance.x = _x
    instance.y = _y
    instance.level = _level
    instance.size = 30

    instance.body = love.physics.newBody (World, instance.x, instance.y, "dynamic")
    instance.body:setMass(10)
    instance.body:setLinearDamping( 0.4 )
    instance.shape = love.physics.newCircleShape(instance.size)
    instance.fixture = love.physics.newFixture(instance.body, instance.shape, 1)
           
    instance.type = "enemy"
    instance.quads = {}
    instance.onScreen = true

    table.insert(Enemies, instance)
end

function Enemy:update(dt, player_x, player_y, j)
    self:move(dt, player_x, player_y, j)
    
    for i = 1, self.animation.max_frames do
       self.quads[i] = love.graphics.newQuad(QUAD_WIDTH * (i-1),0,QUAD_WIDTH,QUAD_HEIGH,SPRITE_WIDTH,SPRITE_HEIGH)
    end

    if self.life <= 0 then
        self.onScreen = false
    end

    self:removeEnemy(j, self.onScreen)

end

function Enemy.updateAll(dt, player_x, player_y)
    for i, instance in ipairs(Enemies) do
        instance:update(dt, player_x, player_y, i)
    end
end

function Enemy:move(dt, player_x, player_y, i)


    local distance = self:distance(player_x, player_y)

    local dx = player_x - self.body:getX()
    local dy = player_y - self.body:getY()

    --[[
    if distance > P_size + self.size then
        self.x = self.x + dx / distance * 100 * dt
        self.y = self.y + dy / distance * 100 * dt
        self.body:setPosition(self.x, self.y)
    else
        self.x = self.x - dx / distance * 100 * dt
        self.y = self.y - dy / distance * 100 * dt
        self.body:setPosition(self.x, self.y)
    end
    ]]

    self.y = self.body:getY()
    self.x = self.body:getX()
    local tx,ty
    if dx > 0 then
        tx = 1
    elseif dx < 0  then
        tx = -1
    else
        tx = 0
    end
    if dy > 0 then
        ty = 1
    elseif dy < 0  then
        ty = -1
    else
        ty = 0
    end
    --self.body:applyForce(tx * 200,ty * 200)
    self.body:applyForce(dx / distance * 200,dy / distance * 200)
    if dx < 0  then
        self.animation.idle = false
        self.animation.direction = "left"
    else
        self.animation.idle = false
        self.animation.direction = "right"
    end
    if not self.animation.idle then
        self.animation.timer = self.animation.timer + dt

        if self.animation.timer > 0.2 then
            self.animation.timer = 0.1

            self.animation.frame = self.animation.frame + 1

              if(self.animation.frame > self.animation.max_frames) then
                self.animation.frame = 1
            end
        end
    end

end


function Enemy:removeEnemy(index, onScreen)
    if onScreen == false then
        table.remove(Enemies, index)
    end
end

function Enemy:activeEnemies()
    return Enemies
end

function Enemy:distance (player_x, player_y)
    return math.sqrt((self.x - player_x) ^ 2 + (self.y - player_y) ^ 2)
end

function DistanceFrom(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2) 
end

function Enemy.drawAll()
    for i,instance in ipairs(Enemies) do
        instance:draw()
    end
end

function Enemy:draw()

    --love.graphics.print(angle, self.body:getX(), self.body:getY()+ 70)
    love.graphics.print(self.body:getX(),self.body:getX(), self.body:getY()+ 100)
    love.graphics.print(self.body:getY(),self.body:getX(), self.body:getY()+ 110)
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.size)
    --love.graphics.scale(1)
    if self.animation.direction == "right" then
        love.graphics.draw(self.sprite, self.quads[self.animation.frame],self.body:getX() - QUAD_WIDTH / 2,self.body:getY() -QUAD_HEIGH /2)
    else
        love.graphics.draw(self.sprite, self.quads[self.animation.frame],self.body:getX()- QUAD_WIDTH / 2,self.body:getY() -QUAD_HEIGH /2,0,-1,1,QUAD_WIDTH,0)
    end
    
   
end

return Enemy