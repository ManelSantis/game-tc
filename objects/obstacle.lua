local Obstacle = {}

function Obstacle:load(_posx,_posy)

    self.b = love.physics.newBody(World, _posx,_posy, "dynamic")  -- set x,y position (400,200) and let it move and hit other objects ("dynamic")
    self.b:setMass(10)                                        -- make it pretty light
    self.s = love.physics.newCircleShape(50)                  -- give it a radius of 50
    self.f = love.physics.newFixture(self.b, self.s)          -- connect body to shape
    self.f:setRestitution(0.4)                                -- make it bouncy
    self.f:setUserData("Ball")
    self.b:setLinearDamping( 0.4 )
end

function Obstacle:update(dt)
    
   
end

   

function Obstacle:draw()
    love.graphics.circle("fill", self.b:getX(),self.b:getY(),self.s:getRadius(), 20)
end

return Obstacle