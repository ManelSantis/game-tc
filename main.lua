_G.love = require("love")
_G.camera = require("libraries/camera")
local scene = {}
local player = require "player"
local enemy = require "objects/enemy"
local munition = require "objects/munition"
local atirar = true

function love.load()
    _G.cam = camera()
    local show_debugging = true

    _G.background = love.graphics.newImage("img/jammy-jellyfish-wallpaper.jpg")
    player = Player(show_debugging, background:getWidth(), background:getHeight())
    
    _G.enemies = {
        enemy(1)
    } 
end

function love.update(dt)
    player:movePlayer()
    cam:lookAt(player.x,player.y)

    for i = 1, #enemies do
        if not enemies[i]:checkTouched(player.x, player.y, player.size) then
            enemies[i]:move(player.x, player.y)    
            --table.insert(enemies, 1, enemy(2))

        end
    end

    --if #scene > 0 then
    for i = 1, #scene do
        scene[i]:moveMunition()
    end
    --end

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

    if atirar == true and love.keyboard.isDown("space") then
        munition = Munition(love.mouse.getX(),love.mouse.getY(), player.x, player.y)
        table.insert(scene, munition)
        atirar = false
    elseif not love.keyboard.isDown("space") then
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
        for i = 1, #enemies do
            enemies[i]:draw()
        end
        player:draw()

        for i = 1, #scene do
            scene[i]:draw()
        end
        --love.graphics.setColor(0, 0, 0)
    cam:detach()

    

    love.graphics.print(love.timer.getFPS(), 10, 10)
    love.graphics.print(player.x, 50, 50)
    love.graphics.print(player.y, 60, 60)
    love.graphics.print(#scene, 80, 80)
    
end

