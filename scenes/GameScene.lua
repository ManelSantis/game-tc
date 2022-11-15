
local GameScene = {}

_G.camera = require "libraries/camera"

local Player = require("player")
local Enemy = require("objects/enemy")
local Bullet = require("objects/bullet")
local Laser = require("objects/laser")
local Obstacle = require("objects/obstacle")
local Drop = require("objects/drop")

local atirar = true

local music
local projectileSound
local heart

local startShootTimer = 0.5
local shootTimer = 0
local startLaserShootTimer = 2
local laserShootTimer = 0

local countEnemies = 0
local waveCount = 0

POSSIBLE_DROPS_X = {}
POSSIBLE_DROPS_Y = {}

LASER = false
LASER_TIMER = 0
END_LASER = 0
SLOW = false
SLOW_TIMER = 0
END_SLOW = 0
SPEED = false
SPEED_TIMER = 0
END_SPEED = 0
INVENSIBLE = false
INVENSIBLE_TIMER = 0
END_INVENSIBLE = 0

HEAL = 0

function GameScene:load()
    _G.cam = camera()
    World = love.physics.newWorld(0, 0)

    _G.background = love.graphics.newImage("img/background.png")
    heart = love.graphics.newImage("img/heart.png")
    HEARTW, HEARTH = 32, 32
    HEARTQW = 16
    HEARTQH = HEARTH
    
    HEART_QUADS = {}

    for i = 1, 2 do
        HEART_QUADS[i] = love.graphics.newQuad(HEARTQW * (i-1),0, HEARTQW, HEARTQH, HEARTW, HEARTH)
    end


    music = love.audio.newSource("audio/Blast From The Past - Jeremy Black.mp3", "stream")
    music:setVolume(0.5)
    projectileSound = love.audio.newSource("audio/376694__daleonfire__laser.wav","stream")
    Player:load(background:getWidth(), background:getHeight(), 30, 100, 100)
    
    Enemy:load()
    Bullet:load(background:getWidth(), background:getHeight())
    Laser:load()
    Drop:load()
    Enemy:addEnemy(1, 20, Player.x, Player.y, background:getWidth(), background:getHeight())
    Enemy:addEnemy(2, 20, Player.x, Player.y, background:getWidth(), background:getHeight())
    countEnemies = #Enemy:activeEnemies()
    waveCount = countEnemies
    
    Obstacle:load(400,600)

    PLAYER_DEAD = false
end

function GameScene:update(dt)
    if not music:isPlaying( ) then
		love.audio.play( music )
	end

    if PLAYER_DEAD == true then
		music:stop();
		changeScene("GameOverScene") --switch to Scene2
	end


    if love.keyboard.isDown('n') then
        music:pause();
         changeScene("GameOverScene")
     end
     if love.keyboard.isDown('m') then
        music:pause();
         changeScene("GameOverScene")
     end
    _G.mX ,_G.mY = cam:mousePosition()
    
    World:update(dt)
    Player:update(dt, Enemy:activeEnemies())
    
    cam:lookAt(Player.body:getX(), Player.body:getY()) 
    Enemy.updateAll(dt, Player.body:getX(), Player.body:getY())
    Drop.updateAll(dt, Player.body:getX(), Player.body:getY())
    Bullet.updateAll(dt, Enemy:activeEnemies())
    Laser.updateAll(dt, Enemy:activeEnemies())
    VerifyCam()
    
    if LASER == false then
        Shooting()
        if shootTimer >=0 then
            shootTimer = shootTimer -dt
        end
    end
    
    DropsTimers(dt)
    
    countEnemies = #Enemy:activeEnemies()
    
    if countEnemies == 0 then
        Spawn()
    end

    for i=1, #POSSIBLE_DROPS_X do
        local verify = math.random(1, 100)

        if (verify >= 1) and (verify <= 20) then
            Drop:addDrop(POSSIBLE_DROPS_X[i], POSSIBLE_DROPS_Y[i], math.random(1, 5))
        end
    end

    for i=1, #POSSIBLE_DROPS_X do
        table.remove(POSSIBLE_DROPS_X, i)
        table.remove(POSSIBLE_DROPS_Y, i)
    end

    Player.life = Player.life + HEAL
    
    if (Player.life > 100) then
        Player.life = 100
    end

    HEAL = 0
end

function Spawn()
    waveCount = waveCount + 3

    for i = 1, waveCount do
        Enemy:addEnemy(math.random(1, 4), 20, Player.x, Player.y, background:getWidth(), background:getHeight())
    end
end

function DropsTimers(dt)
    if LASER == true and END_LASER <= 15000 then
        ShootLaser()
        if laserShootTimer >=0 then
            laserShootTimer = laserShootTimer - dt
        end
        END_LASER = (love.timer.getTime() -  LASER_TIMER) * 1000
    else
        LASER = false
    end

    if SLOW == true and END_SLOW <= 8000 then
        END_SLOW = (love.timer.getTime() -  SLOW_TIMER) * 1000
    else
        SLOW = false
    end

    if SPEED == true and END_SPEED <= 7000 then
        END_SPEED = (love.timer.getTime() -  SPEED_TIMER) * 1000
    else
        SPEED = false
    end

    if INVENSIBLE == true and END_INVENSIBLE <= 6000 then 
        END_INVENSIBLE = (love.timer.getTime() -  INVENSIBLE_TIMER) * 1000
    else
        INVENSIBLE = false
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

function GameScene:draw()
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
    Drop.drawAll()
    Obstacle:draw()
    cam:detach()
    love.graphics.print('Memory actually used (in kB): ' .. collectgarbage('count'), 10,10)

    for i = 1, Player.life do
        if i % 5 == 0 and not (i % 10 == 0) then
            love.graphics.draw(heart, HEART_QUADS[1], 20 + i * 3, 50)
        end
        if i % 10 == 0 then 
            love.graphics.draw(heart, HEART_QUADS[2], 20 + i * 3, 50)
        end
        
    end
    --love.graphics.draw(heart,90,50)
    --love.graphics.draw(heart,130,50)
   --[[ Camera:apply()
    Player:draw()
    Camera:clear()]]
    love.graphics.setNewFont(20)
    love.graphics.printf(score, 1190, 20, 80, 'right')

end

return GameScene