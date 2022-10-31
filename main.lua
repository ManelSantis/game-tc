_G.love = require "love"
_G.camera = require "libraries/camera"

local Player = require("player")
local Enemy = require("objects/enemy")
local Bullet = require("objects/bullet")
local Laser = require("objects/laser")

local atirar = true

local music
local projectileSound
local heart

local startShootTimer = 0.5
local shootTimer = 0
local startLaserShootTimer = 2
local laserShootTimer = 0

local gun = 1
function love.load()
    _G.cam = camera()
    World = love.physics.newWorld(0, 0)
    World:setCallbacks(beginContact, endContact)

    _G.background = love.graphics.newImage("img/background.png")
    heart = love.graphics.newImage("img/heart.png")

    music = love.audio.newSource("audio/Blast From The Past - Jeremy Black.mp3", "stream")
    music:setVolume(0.5)
    projectileSound = love.audio.newSource("audio/376694__daleonfire__laser.wav","stream")
    Player:load(background:getWidth(), background:getHeight(), 30, 250, 250)
    
    Enemy:load()
    Bullet:load(background:getWidth(), background:getHeight())
    Laser:load()
    Enemy:addEnemy(1, 20)
    Enemy:addEnemy(2, 20)
    Enemy:addEnemy(3, 20)
    Enemy:addEnemy(4, 20)
end

function love.update(dt)
    if not music:isPlaying( ) then
		love.audio.play( music )
	end

    _G.mX ,_G.mY = cam:mousePosition()
    
    World:update(dt)
    Player:update(dt)
    
    cam:lookAt(Player.x, Player.y) 
    Enemy.updateAll(dt, Player.body:getX(), Player.body:getY())
    Bullet.updateAll(dt, Enemy:activeEnemies())
    Laser.updateAll(dt, Enemy:activeEnemies())
    VerifyCam()
    if gun == 1 then
        Shooting()
        if shootTimer >=0 then
            shootTimer = shootTimer -dt
            
        end
        
    elseif gun  == 2 then
    
        ShootLaser()
        if laserShootTimer >=0 then
            laserShootTimer = laserShootTimer -dt
            
        end
    end
    
    
    if love.keyboard.isDown('1') then
        gun = 1
    end
    if love.keyboard.isDown('2') then
        gun = 2
    end
end

function VerifyCam()
    local w = background:getWidth() - love.graphics.getWidth() / 2
    local h = background:getHeight() - love.graphics.getHeight() / 2
    local ww = 0 + love.graphics.getWidth() / 2
    local hh = 0 + love.graphics.getHeight() / 2

    if cam.x > w then
        cam.x = w
    end

    if cam.x < ww then 
        cam.x = ww 
    end 

    if cam.y > h then
        cam.y = h
    end

    if cam.y < hh then 
        cam.y = hh
    end 
end

function ShootLaser()
    if atirar == true and love.mouse.isDown(1)  then
        if laserShootTimer <= 0 then
            
            local mouseX, mouseY = cam:mousePosition()
            
            Laser:addLaser(mouseX, mouseY, Player.x, Player.y)
            --projectileSound:stop()
            --projectileSound:play()
            local clone = projectileSound:clone()
            clone:play()
            atirar = false

            laserShootTimer = startLaserShootTimer
        end
    elseif not love.mouse.isDown(1) then
        atirar = true
    end
end

function Shooting()
    if atirar == true and love.mouse.isDown(1) then
        if shootTimer <= 0 then
            local mouseX, mouseY = cam:mousePosition()
            
            Bullet:addBullet(mouseX, mouseY, Player.x, Player.y)
            --projectileSound:stop()
            --projectileSound:play()
            
            local clone = projectileSound:clone()
            clone:play()
            atirar = false
            shootTimer = startShootTimer
        end

    elseif not love.mouse.isDown(1) then
        atirar = true
    end
end

function love.draw()
    cam:attach()
    for i = 0, love.graphics.getWidth() / background:getWidth() do
        for j = 0, love.graphics.getHeight() / background:getHeight() do
            love.graphics.draw(background, i * background:getWidth(), j * background:getHeight())
        end
    end
    Bullet.drawAll()
    Laser.drawAll()
    Player:draw()
    Enemy.drawAll()
    cam:detach()
    love.graphics.print('Memory actually used (in kB): ' .. collectgarbage('count'), 10,10)
    love.graphics.print('shootTimer: ' .. shootTimer, 10,90)
    for i = 1, Player.life, 10 do
        if Player.life % 10 == 0 then
            love.graphics.draw(heart,20 + i *3,50)

        end
    end
    --love.graphics.draw(heart,90,50)
    --love.graphics.draw(heart,130,50)
   --[[ Camera:apply()
    Player:draw()
    Camera:clear()]]


end