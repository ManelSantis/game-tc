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
    self.life = 100
    self.body = love.physics.newBody (World, self.x, self.y, "dynamic")
    self.shape = love.physics.newCircleShape(self.size)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)
    self.body:setLinearDamping( 0.4 )
    self.type = "player"

    self.sprite = love.graphics.newImage("img/char_idle.png")
    self.sprite_Walk = love.graphics.newImage("img/walk.png")
    self.animation = {
            direction = "right",
            idle = false,
            frame = 1,
            max_frames = 4,
            speed = 20,
            timer = 0.5
    }
    SPRITE_WIDTH, SPRITE_HEIGH = 240, 120
    QUAD_WIDTH = 60
    QUAD_HEIGH = SPRITE_HEIGH

    self.quads = {}
    for i = 1, self.animation.max_frames do
        self.quads[i] = love.graphics.newQuad(QUAD_WIDTH * (i-1),0,QUAD_WIDTH,QUAD_HEIGH,SPRITE_WIDTH,SPRITE_HEIGH)
    end

    self.gun = love.graphics.newImage("img/gun.png")
    self.gunAngle = 0

    self.jetSound = love.audio.newSource("audio/402816__jacksonacademyashmore__jetpack-loop.wav","stream")
    self.jetSound:setVolume(0.5)
end

function Player:update(dt)
    self:move(dt)
    
    local deltaX =  self.body:getX() - mX 
    local deltaY = self.body:getY() - mY
   
    if mX > self.body:getX() then
        self.animation.direction = "right"
    else
        self.animation.direction = "left"
    end

    self.gunAngle = math.atan2(deltaY, deltaX) 
    if self.animation.direction == "right" then
        self.gunAngle =  self.gunAngle + math.rad(180)
    end
    if self.animation.direction == "left" then
        self.gunAngle =  self.gunAngle  
    end
    --if not self.animation.idle then
        self.animation.timer = self.animation.timer + dt

        if self.animation.timer > 0.2 then
            self.animation.timer = 0.1

            self.animation.frame = self.animation.frame + 1

              if(self.animation.frame > self.animation.max_frames) then
                self.animation.frame = 1
            end
        end
    --end
end

function Player:move(dt)

    self.animation.idle = true
    self.jetSound:pause()
    if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        if self.body:getX() < (self.lx - self.size - 10) then
            self.x = self.x + self.velX * dt
            --self.body:applyForce(self.velX, 0)
        end
        self.animation.idle = false
        self.animation.direction = "right"
        self.jetSound:play()
    end

    if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
        if self.body:getX() > (0 + self.size + 10) then
            self.x = self.x - self.velX * dt
            --self.body:applyForce(-self.velX,0)
        end
        self.animation.idle = false
        self.animation.direction = "left"
        self.jetSound:play()
    end

    if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
        if self.body:getY() < (self.ly - self.size - 40) then
            self.y = self.y + self.velY * dt
            --self.body:applyForce(0,self.velY)
        end
        self.animation.idle = false
        self.jetSound:play()
    end

    if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
        if self.body:getY() > (0 + self.size + 20) then
            self.y = self.y - self.velY * dt
            --self.body:applyForce(0, -self.velY)
        end
        self.animation.idle = false
        self.jetSound:play()
    end

    if self.body:getX() > (self.lx - self.size - 10) then
        self.body:setX(self.lx - self.size - 10)
    end

    if self.body:getX() < (0 + self.size + 10) then
        self.body:setX(0 + self.size + 10)
    end

    if self.body:getY() > (self.ly - self.size - 50) then
        self.body:setY(self.ly - self.size - 50)
    end

    if self.body:getY() < (0 + self.size + 30) then
        self.body:setY(0 + self.size + 30)
    end

    
    
    --self.x,self.y =  self.body:getX(),self.body:getY()
    self.body:setPosition(self.x, self.y)
end

function Player:draw()
    --love.graphics.setColor(248 / 255, 255 / 255, 1 / 255)
    if self.animation.direction == "right" then
        if not self.animation.idle then
            love.graphics.draw(self.sprite_Walk, self.quads[self.animation.frame],self.body:getX() - QUAD_WIDTH / 2,self.body:getY() -QUAD_HEIGH /2)
        else
            love.graphics.draw(self.sprite, self.quads[self.animation.frame],self.body:getX() - QUAD_WIDTH / 2,self.body:getY() -QUAD_HEIGH /2)
        end
    elseif self.animation.direction == "left" then
        if not self.animation.idle then
            love.graphics.draw(self.sprite_Walk, self.quads[self.animation.frame],self.body:getX()- QUAD_WIDTH / 2,self.body:getY() -QUAD_HEIGH /2,0,-1,1,QUAD_WIDTH,0)
        else
            love.graphics.draw(self.sprite, self.quads[self.animation.frame],self.body:getX()- QUAD_WIDTH / 2,self.body:getY() -QUAD_HEIGH /2,0,-1,1,QUAD_WIDTH,0)
        end
    end

    if self.animation.direction == "right" then
        love.graphics.draw(self.gun,self.body:getX() - 5,self.body:getY() + 5,self.gunAngle,1,1,15,5)
    else
        love.graphics.draw(self.gun,self.body:getX() +5,self.body:getY() + 5,self.gunAngle,-1,1,15,5)
    end

end

return Player