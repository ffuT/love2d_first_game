local Entities = require("Entities")

function love.load()
    WIDTH = 1440
    HEIGHT = 810
    DeltaTime = 0.0

    BG_Color = {0.23, 0.23, 0.23}

    Entitylist = {}
    
    Player = {
        x = WIDTH/2, 
        y = HEIGHT/2, 
        velx = 0.0,
        vely = 0.0,
        acc = 12.25,
    }
    function Player:getspeed ()
        return self.velx + self.vely
    end
    love.window.setMode(WIDTH, HEIGHT)
    --love.window.setVSync(0)
end

function love.update(dt)
    DeltaTime = dt
    local moving = false

    -- Player Accel
    local acx = 0
    local acy = 0

    -- keyboard handling --
    if love.keyboard.isDown("w") then
        acy = -Player.acc * dt;
        moving = true
    end
    if love.keyboard.isDown("s") then
        acy = Player.acc * dt;
        moving = true
    end
    if love.keyboard.isDown("d") then
        acx = Player.acc * dt;
        moving = true
    end
    if love.keyboard.isDown("a") then
        acx = -Player.acc * dt;
        moving = true
    end
    if love.keyboard.isDown("space") then
        table.insert(Entitylist, Entities.newEnemy(love.math.random(0,WIDTH), love.math.random(0,HEIGHT), 2.31))
    end

    -- update player movement --
    Player.velx = Player.velx + acx
    Player.vely = Player.vely + acy

    local speed = Player.velx + Player.vely
    local maxspeed = 3.25

    if Player.velx > maxspeed then
        Player.velx = maxspeed
    end
    if Player.vely > maxspeed then
        Player.vely = maxspeed
    end
    if Player.velx < -maxspeed then
        Player.velx = -maxspeed 
    end
    if Player.vely < -maxspeed then
        Player.vely = -maxspeed 
    end

    Player.x = Player.x + Player.velx * dt * 100;
    Player.y = Player.y + Player.vely * dt * 100;
    
    if not moving then -- friction
        Player.velx = Player.velx -Player.velx * dt
        Player.vely = Player.vely -Player.vely * dt
    end

    for _, entity in ipairs(Entitylist) do
       entity:update(dt, Player.x, Player.y)
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
    love.graphics.rectangle("fill", Player.x - 20, Player.y - 20, 40, 40)
    
    -- debug info
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("fps: " .. love.timer.getFPS(), 10, 10)
    love.graphics.print("pos: " .. 
    string.format("%.1f", Player.x) .. " " .. string.format("%.2f", Player.y), 10, 30)
    love.graphics.print("enemys: " .. #Entitylist, 10, 50)
end

