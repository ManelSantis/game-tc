_G.love = require("love")
local player = require ("player")

function love.load()
    local show_debugging = true
    
    player = Player(show_debugging)
end

function love.update(dt)
   player:movePlayer()
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
    player:draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(love.timer.getFPS(), 10, 10)
end