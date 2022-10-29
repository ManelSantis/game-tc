local Player = {}

function Player:load(limit_x, limit_y, _size, speedX, speedY)
    self.x = limit_x / 2
    self.y = limit_y / 2
    self.lx = limit_x
    self.ly = limit_y
    self.size = _size
    _G.P_size = _size
    self.velX = speedX
    self.velY = speedY

    self.body = love.physics.newBody (World, self.x, self.y, "dynamic")
    self.shape = love.physics.newCircleShape(self.size)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)

    self.type = "player"

    self.sprite = love.graphics.newImage("img/boneco_tile.png")
    self.animation = {
            direction = "right",
            idle = false,
            frame = 1,
            max_frames = 4,
            speed = 20,
            timer = 0.5
    }
    SPRITE_WIDTH, SPRITE_HEIGH = 260, 260
    QUAD_WIDTH = 60
    QUAD_HEIGH = SPRITE_HEIGH/2

    self.quads = {}
    for i = 1, self.animation.max_frames do
        self.quads[i] = love.graphics.newQuad(QUAD_WIDTH * (i-1),0,QUAD_WIDTH,QUAD_HEIGH,SPRITE_WIDTH,SPRITE_HEIGH)
    end

    self.gun = love.graphics.newImage("img/gun.png")
    self.gunAngle = 0
end

function Player:update(dt)
    self:move(dt)
    
    local deltaX =  self.body:getX() - mX 
    local deltaY = self.body:getY() - mY
   
    self.gunAngle = math.atan2(deltaY, deltaX) 
    if self.animation.direction == "right" then
        self.gunAngle =  self.gunAngle + math.rad(180)
    end
    if self.animation.direction == "left" then
        self.gunAngle =  self.gunAngle  
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

function Player:move(dt)
    if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        if self.x < (self.lx - self.size - 10) then
            self.x = self.x + self.velX * dt
        end
        self.animation.idle = false
        self.animation.direction = "right"
    end

    if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
        if self.x > (0 + self.size + 10) then
            self.x = self.x - self.velX * dt
        end
        self.animation.idle = false
        self.animation.direction = "left"
    end

    if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
        if self.y < (self.ly - self.size - 10) then
            self.y = self.y + self.velY * dt
        end
    end

    if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
        if self.y > (0 + self.size + 10) then
            self.y = self.y - self.velY * dt
        end
    end   

    self.body:setPosition(self.x, self.y)
end

function Player:beginContact(a, b, collision)

end

function Player:endContact(a, b, collision)

end

function Player:draw()
    --love.graphics.setColor(248 / 255, 255 / 255, 1 / 255)
    love.graphics.circle("fill", self.x, self.y, self.size)
    if self.animation.direction == "right" then
        love.graphics.draw(self.sprite, self.quads[self.animation.frame],self.body:getX() - QUAD_WIDTH / 2,self.body:getY() -QUAD_HEIGH /2)
    else
        love.graphics.draw(self.sprite, self.quads[self.animation.frame],self.body:getX()- QUAD_WIDTH / 2,self.body:getY() -QUAD_HEIGH /2,0,-1,1,QUAD_WIDTH,0)
    end

    
        
        
    
        --love.graphics.draw(self.gun,self.body:getX(),self.body:getY() + 5,self.gunAngle,1,1,25,10)
   

    if self.animation.direction == "right" then
        love.graphics.draw(self.gun,self.body:getX() - 11,self.body:getY() + 5,self.gunAngle,1,1,8,5)
    else
        love.graphics.draw(self.gun,self.body:getX() +11,self.body:getY() + 5,self.gunAngle,-1,1,8,5)
    end
    
    

end

return Player