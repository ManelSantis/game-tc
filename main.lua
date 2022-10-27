_G.love = require "love"
_G.camera = require "libraries/camera"

local Player = require("player")
local Enemy = require("objects/enemy")
local Bullet = require("objects/bullet")
local atirar = true

function love.load()
    _G.cam = camera()
    World = love.physics.newWorld(0, 0) 

    _G.background = love.graphics.newImage("img/background.png")
    
    Player:load(background:getWidth(), background:getHeight(), 30, 250, 250)
    
    Enemy:load(1, 20)
    Bullet:load()
end

function love.update(dt)
    World:update(dt)
    Player:update(dt)
    cam:lookAt(Player.x, Player.y) 
    if not Enemy:checkTouched(Player.x, Player.y, Player.size) then 
        Enemy:update(dt, Player.body:getX(), Player.body:getY())
    end
    Bullet.updateAll(dt)
    VerifyCam()
    Shooting()
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

function Shooting()
    if atirar == true and love.mouse.isDown(1) then
        local mouseX, mouseY = cam:mousePosition()
        Bullet:addBullet(mouseX, mouseY, Player.x, Player.y)
        atirar = false
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
    Player:draw()
    Enemy:draw()
    cam:detach()

   --[[ Camera:apply()
    Player:draw()
    Camera:clear()]]


end