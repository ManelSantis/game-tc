_G.love = require("love")
_G.camera = require("libraries/camera")
local player = require ("player")
local enemy = require "objects/enemy"
function love.load()
    _G.cam = camera()
    local show_debugging = true
    
    player = Player(show_debugging)

    _G.background = love.graphics.newImage("img/jammy-jellyfish-wallpaper.jpg")
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

end

function animation()
   
    if number < 3 and open == true then
        number = number + 1
        pacman.eni = pacman.eni + 1
    else
        open = false
    end

    if open == false then
        number = number - 1
        pacman.eni = pacman.eni - 1
    end

    if number == 0 then 
        open = true
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
        --love.graphics.setColor(0, 0, 0)
    cam:detach()

    love.graphics.print(love.timer.getFPS(), 10, 10)
end