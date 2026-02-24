local Entities = require("Entities")

local Player
local Enemylist = {}

local BulletPool = {}
local BulletActive = {}

local canvas
local crtShader
local bgColor = { 0.23, 0.23, 0.23 }

local function spawnBullet(x, y, xv, yv)
    local b = table.remove(BulletPool)
    if not b then
        b = {}
    end
    b.x, b.y, b.xv, b.yv = x, y, xv, yv
    b.alive = true
    table.insert(BulletActive, b)
end

local function killBullet(i)
    local b = BulletActive[i]
    b.alive = false
    BulletActive[i] = BulletActive[#BulletActive]
    BulletActive[#BulletActive] = nil
    table.insert(BulletPool, b)
end

function love.load()
    WIDTH = 1440
    HEIGHT = 810

    --love.window.setVSync(0)
    love.window.setMode(WIDTH, HEIGHT)
    canvas = love.graphics.newCanvas()
    crtShader = love.graphics.newShader("Shaders/crt.glsl")

    Player = Entities.newPlayer()
end

function love.update(dt)
    if love.math.random(10) == 1 then
        table.insert(Enemylist, Entities.newEnemy(love.math.random(0, WIDTH), love.math.random(0, HEIGHT), 20))
    end

    Player:update(dt);
    if Player.firing then
        spawnBullet(Player.body.x, Player.body.y, Player.aimx, Player.aimy)
        Player.firing = false
        Player.aimx, Player.aimy = 0, 0
    end
    
    for i = #BulletActive, 1, -1 do
        BulletActive[i].x = BulletActive[i].x + 1200 * dt * BulletActive[i].xv
        BulletActive[i].y = BulletActive[i].y + 1200 * dt * BulletActive[i].yv
        if BulletActive[i].x > WIDTH or BulletActive[i].x < 0 or BulletActive[i].y > HEIGHT or BulletActive[i].y < 0 then
            killBullet(i)
        end
    end

    for i = #Enemylist, 1, -1 do
        local entity = Enemylist[i]
        entity:update(dt, Player.body)
        -- on contact delete self + dmg player
        if entity.collider:CheckCollision(Player.collider) then
            table.remove(Enemylist, i)
            Player.health = Player.health - 1
        end
    end
end

function love.draw()
    -- set canvas and clear it
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    love.graphics.setBackgroundColor(bgColor)

    -- draw entities
    for _, entity in ipairs(Enemylist) do
        entity:draw()
    end

    for _, bullet in ipairs(BulletActive) do
        love.graphics.setColor(1, 1, 1)
        love.graphics.ellipse("fill", bullet.x, bullet.y, 5, 5);
    end


    -- draw player
    Player:draw()

    -- draw debug info
    love.graphics.setNewFont(18)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("fps: " .. love.timer.getFPS(), 10, 10)
    love.graphics.print("pos: " ..
    string.format("%.1f", Player.body.x) .. " " .. string.format("%.2f", Player.body.y), 10, 30)
    love.graphics.print("enemys: " .. #Enemylist, 10, 50)
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