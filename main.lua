_G.love = require "love" 
_G.camera = require "libraries/camera"
_G.background = love.graphics.newImage("img/jammy-jellyfish-wallpaper.jpg")
_G.world = love.physics.newWorld(0, 0, true)
_G.player = require "player"
_G.objectsOnScene = {}
local shootsOnScene = {}

local enemy = require "objects/enemy"
local munition = require "objects/munition"
local atirar = true

function love.load()
    _G.cam = camera()
    local show_debugging = true

    player = Player(background:getWidth(), background:getHeight(), world, 30, 250, 250)
    player:createPlayer()
    table.insert(objectsOnScene, player)

    enemy = Enemy(1, world, 20)
    enemy:createEnemy()
    _G.enemies = {
        enemy
    } 
    table.insert(objectsOnScene, enemy)
end

function love.update(dt)
    player:movePlayer(dt)
    cam:lookAt(player.x,player.y)

    for i = 1, #enemies do
        if not enemies[i]:checkTouched(player.x, player.y, player.size) then
            enemies[i]:moveEnemy(player.x, player.y)    
            --table.insert(enemies, 1, enemy(2))
        end
    end

    --if #scene > 0 then
    for i = 1, #shootsOnScene do
        shootsOnScene[i]:moveMunition(dt)
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

    if atirar == true and love.mouse.isDown(1) then
        mouseX, mouseY = cam:mousePosition()
        munition = Munition(mouseX, mouseY, player.x, player.y, world)
        munition:createMunition()
        table.insert(objectsOnScene, munition)
        table.insert(shootsOnScene, munition)
        atirar = false
    elseif not love.mouse.isDown(1) then
        atirar = true
    end

    world:update(dt, 1, 1)
end

function love.draw()

    cam:attach()
        for i = 0, love.graphics.getWidth() / background:getWidth() do
            for j = 0, love.graphics.getHeight() / background:getHeight() do
                love.graphics.draw(background, i * background:getWidth(), j * background:getHeight())
            end
        end
        
        for i, body in pairs(world:getBodies()) do
            --objectsOnScene[i]:color()
            for j, fixture in pairs (body:getFixtures()) do
                local shape = fixture:getShape()
                local cx, cy = body:getWorldPoints(shape:getPoint())
                love.graphics.circle("fill", cx, cy, shape:getRadius())
            end
        end
    cam:detach()

    --local mouseX = love.mouse.getX() * cam.scale + cam.x
    --local mouseY = love.mouse.getY() * cam.scale + cam.y
    mouseX, mouseY = cam:mousePosition()
    local o_angle = 0
    local PI = math.pi

    local w = player.x
    local h = player.y
    
    local deltaX = mouseX - w
    local deltaY = mouseY - h

    local rad = math.atan2(deltaY, deltaX)
    --rad = (rad*PI)/360
    love.graphics.print(-math.deg(rad), 50, 50)

    love.graphics.print(250 * math.cos(rad), 70, 70)
    love.graphics.print(250 * math.cos(rad), 90, 90)
end

