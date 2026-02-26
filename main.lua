local Entities = require("Entities")
local Bullets = require("Bullets")
local Particles = require("Particles")

local Player
local points

local canvas
local crtShader
local bgColor = {0.23, 0.23, 0.23}

function love.load()
    WIDTH = 1440
    HEIGHT = 810

    love.window.setMode(WIDTH, HEIGHT)
    canvas = love.graphics.newCanvas()
    crtShader = love.graphics.newShader("Shaders/crt.glsl")

    Player = Entities.newPlayer()
    points = 0
end

function love.update(dt)
    points = points + Entities:getPoints() -- get current pointpool

    if love.math.random(10) == 1 then --fps dependant needs fix
        Entities:spawnEnemy(love.math.random(0, WIDTH),love.math.random(0, WIDTH))
    end

    if love.keyboard.isDown("r") then -- DEBUG PARTICLE SPAWNER
        Particles:spawnParticleEffect(500, 500, 0.0, 0.0, Particles.Effects.explosion)
    end

    Player:update(dt);

    Particles:update(dt)

    Bullets:update(dt, Entities.Enemylist)

    if Player.firing then
        Particles:spawnParticleEffect(Player.body.x, Player.body.y, Player.aimx, Player.aimy, Particles.Effects.muzzleFlash)
        for i = 1, love.math.random(3, 5) , 1 do
            local theta = math.sin(math.rad(love.math.random(-12, 12))) -- [-12:12] = 24deg window spread
            local phi = math.sin(math.rad(love.math.random(-12, 12)))
            Bullets:spawnBullet(Player.body.x, Player.body.y, Player.aimx + theta, Player.aimy + phi)
        end

        Player.firing = false
        Player.aimx, Player.aimy = 0.0, 0.0
    end

    Entities:updateEnemies(dt, Player)
end

function love.draw()
    -- set canvas and clear it
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    love.graphics.setBackgroundColor(bgColor)

    Entities:drawEnimies()

    Bullets:draw()

    Particles:draw()

    Player:draw()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("POINTS: " .. points, WIDTH/2, 10)

    -- draw debug info
    love.graphics.setNewFont(18)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("fps: " .. love.timer.getFPS(), 10, 10)
    love.graphics.print("pos: " ..
    string.format("%.1f", Player.body.x) .. " " .. string.format("%.2f", Player.body.y), 10, 30)
    love.graphics.print("enemys: " .. #Entities.Enemylist, 10, 50)
    love.graphics.print("health: " .. Player.health, 10, 70)

    -- stop drawing, set shader and render
    love.graphics.setCanvas()
    crtShader:send("resolution", { love.graphics.getWidth(), love.graphics.getHeight() })
    crtShader:send("time", love.timer.getTime())
    love.graphics.setShader(crtShader)
    love.graphics.draw(canvas, 0, 0)
    love.graphics.setShader()
end

function love.keypressed(key)
    Player:keypressed(key)
end