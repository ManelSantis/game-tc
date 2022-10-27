local Enemy = {}

function Enemy:load(_level, _size)
    local dice = math.random(1, 4)
    local _x, _y
    self.sprite = love.graphics.newImage("img/alien_bigger.png")
    self.animation = {
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
    self.touthPLayer = false;
    
   

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
    self.size = 30

    self.body = love.physics.newBody (World, self.x, self.y, "dynamic")
    self.body:setMass(10)
    self.shape = love.physics.newCircleShape(self.size)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)
           
    self.type = "enemy"
    self.quads = {}
end

function Enemy:update(dt, player_x, player_y)
    self:move(dt, player_x, player_y)

    
    for i = 1, self.animation.max_frames do
       self.quads[i] = love.graphics.newQuad(QUAD_WIDTH * (i-1),0,QUAD_WIDTH,QUAD_HEIGH,SPRITE_WIDTH,SPRITE_HEIGH)
    end
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

    if distance > P_size + self.size then
        self.x = self.x + dx / distance * 100 * dt
        self.y = self.y + dy / distance * 100 * dt
        self.body:setPosition(self.x, self.y)
    else
        self.x = self.x - dx / distance * 100 * dt
        self.y = self.y - dy / distance * 100 * dt
        self.body:setPosition(self.x, self.y)
    end


    --self.y = self.body:getY()
    --self.x = self.body:getX()
    --self.body:applyForce(-math.cos(angle) * 200,math.sin(angle) * 200)
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

    --love.graphics.print(angle, self.body:getX(), self.body:getY()+ 70)
    love.graphics.print(self.body:getX(),self.body:getX(), self.body:getY()+ 100)
    love.graphics.print(self.body:getY(),self.body:getX(), self.body:getY()+ 110)
    love.graphics.setColor(1, 1, 1)
    --love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.size)
    --love.graphics.scale(1)
    if self.animation.direction == "right" then
        love.graphics.draw(self.sprite, self.quads[self.animation.frame],self.body:getX() - QUAD_WIDTH / 2,self.body:getY() -QUAD_HEIGH /2)
    else
        love.graphics.draw(self.sprite, self.quads[self.animation.frame],self.body:getX()- QUAD_WIDTH / 2,self.body:getY() -QUAD_HEIGH /2,0,-1,1,QUAD_WIDTH,0)
    end
    
   
end

return Enemy