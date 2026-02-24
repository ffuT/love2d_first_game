local Physics = require("Physics")

local Entities = {}

Entities.newEnemy = function(x, y, health)
    local Enemy = {
        body = Physics.newBody(x, y, 13.20),
        radius = 15,
        collider = Physics.newSphereCollider(x, y, 15),
        health = health,
    }

    function Enemy:draw()
        love.graphics.setColor(0.9, 0.1, 0.1)
        love.graphics.ellipse("fill", self.body.x, self.body.y, self.radius, self.radius);
    end

    function Enemy:update(dt, targetbody)
        local dirx = targetbody.x - self.body.x
        local diry = targetbody.y - self.body.y
        local len = math.sqrt(dirx * dirx + diry * diry)

        -- time it will take to reach target
        local predictiontime = (len / self.body.maxSpeed)

        -- take oposite of own vel + target gives overshoort prediciton
        local predictiondirx = -self.body.velx * predictiontime + dirx
        local predictiondiry = -self.body.vely * predictiontime + diry

        -- update movement from calculated directions
        self.body:integrate(dt, predictiondirx, predictiondiry)
        -- update collision sphere
        self.collider:updatePos(self.body.x, self.body.y)
    end

    return Enemy
end

Entities.newPlayer = function()
    local Player = {
        health = 100,
        body = Physics.newBody(WIDTH / 2, HEIGHT / 2, 20.25),
        collider = Physics.newSphereCollider(WIDTH / 2, HEIGHT / 2, 25),
    }
    Player.body.maxSpeed = 3.2069

    function Player:update(dt)
        -- Player Accel
        local dirx = 0
        local diry = 0

        -- keyboard handling --
        if love.keyboard.isDown("w") then
            diry = diry - 1
        end
        if love.keyboard.isDown("s") then
            diry = diry + 1
        end
        if love.keyboard.isDown("d") then
            dirx = dirx + 1
        end
        if love.keyboard.isDown("a") then
            dirx = dirx - 1
        end
        if love.keyboard.isDown("left") then

        end
        if love.keyboard.isDown("right") then

        end
        if love.keyboard.isDown("up") then

        end
        if love.keyboard.isDown("down") then

        end

        -- Player Movement
        Player.body:integrate(dt, dirx, diry)
        Player.collider:updatePos(Player.body.x, Player.body.y)
        
    end

    
    return Player
end

return Entities