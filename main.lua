local Entities = require("Entities")
local Physics = require("Physics")

function love.load()
    WIDTH = 1440
    HEIGHT = 810
    DeltaTime = 0.0

    BG_Color = {0.23, 0.23, 0.23}

    Entitylist = {}
    
    Player = {
        health = 100,
        body = Physics.newBody(WIDTH/2, HEIGHT/2, 22.25),
        collider = Physics.newSphereCollider(WIDTH/2, HEIGHT/2, 25),
    }
    Player.body.maxSpeed = 2.2069

    love.window.setMode(WIDTH, HEIGHT)
    --love.window.setVSync(0)
end

function love.update(dt)
    DeltaTime = dt

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
        table.insert(Entitylist, Entities.newEnemy(love.math.random(0,WIDTH), love.math.random(0,HEIGHT), 15))
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
    love.graphics.setBackgroundColor(BG_Color)

    -- draw entities
    for _, entity in ipairs(Entitylist) do
        entity:draw()
    end  
    
    -- draw player
    love.graphics.setColor(.1, .43, .91)
    love.graphics.rectangle("fill", Player.body.x - 20, Player.body.y - 20, 40, 40)
    
    -- debug info
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("fps: " .. love.timer.getFPS(), 10, 10)
    love.graphics.print("pos: " .. 
    string.format("%.1f", Player.body.x) .. " " .. string.format("%.2f", Player.body.y), 10, 30)
    love.graphics.print("enemys: " .. #Entitylist, 10, 50)
    love.graphics.print("health: " .. Player.health, 10, 70)
end