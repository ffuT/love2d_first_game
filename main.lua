local Entities = require("Entities")
local Physics = require("Physics")

local canvas
local crtShader
local bgColor = {0.23, 0.23, 0.23}

function love.load()
    WIDTH = 1440
    HEIGHT = 810

    --love.window.setVSync(0)
    love.window.setMode(WIDTH, HEIGHT)
    canvas = love.graphics.newCanvas()
    crtShader = love.graphics.newShader("Shaders/crt.glsl")
    
    Entitylist = {}
    
    Player = {
        health = 100,
        body = Physics.newBody(WIDTH/2, HEIGHT/2, 20.25),
        collider = Physics.newSphereCollider(WIDTH/2, HEIGHT/2, 25),
    }
    Player.body.maxSpeed = 3.2069
end

function love.update(dt)

    -- Player Accel
    local dirx = 0
    local diry = 0

    -- keyboard handling --
    if love.keyboard.isDown("w") then
        diry = diry -1
    end
    if love.keyboard.isDown("s") then
        diry = diry + 1
    end
    if love.keyboard.isDown("d") then
        dirx = dirx + 1
    end
    if love.keyboard.isDown("a") then
        dirx = dirx -1
    end
    if love.keyboard.isDown("space") then
        table.insert(Entitylist, Entities.newEnemy(love.math.random(0,WIDTH), love.math.random(0,HEIGHT), 20))
    end

    -- Player Movement
    Player.body:Intergrate(dt, dirx, diry)
    Player.collider:updatePos(Player.body.x, Player.body.y)

    for i = #Entitylist, 1, -1 do
        local entity = Entitylist[i]
        entity:update(dt, Player.body)
        if entity.collider:CheckCollision(Player.collider) then
            table.remove(Entitylist, i)
            Player.health = Player.health - 1
        end
    end
end

function love.draw()
    love.graphics.setCanvas(canvas)
    love.graphics.clear()

    love.graphics.setBackgroundColor(bgColor)

    
    -- draw entities
    for _, entity in ipairs(Entitylist) do
        entity:draw()
    end
    
    -- draw player
    love.graphics.setColor(.1, .43, .91)
    love.graphics.rectangle("fill", Player.body.x - 20, Player.body.y - 20, 40, 40)
    
    -- debug info
    love.graphics.setNewFont(18)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("fps: " .. love.timer.getFPS(), 10, 10)
    love.graphics.print("pos: " .. 
    string.format("%.1f", Player.body.x) .. " " .. string.format("%.2f", Player.body.y), 10, 30)
    love.graphics.print("enemys: " .. #Entitylist, 10, 50)
    love.graphics.print("health: " .. Player.health, 10, 70)
    
    love.graphics.setCanvas()
    
    crtShader:send("resolution", {love.graphics.getWidth(), love.graphics.getHeight()})
    crtShader:send("time", love.timer.getTime())

    love.graphics.setShader(crtShader)
    love.graphics.draw(canvas, 0, 0)
    love.graphics.setShader()
end