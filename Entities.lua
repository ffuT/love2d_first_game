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

        local overshootaccuracy = 0.88 -- lower value = bad tracking

        -- take oposite of own vel + target gives overshoot prediciton
        local predictiondirx = -self.body.velx * overshootaccuracy * predictiontime + dirx
        local predictiondiry = -self.body.vely * overshootaccuracy * predictiontime + diry

        -- update pos
        self.body:integrate(dt, predictiondirx, predictiondiry)
        self.collider:updatePos(self.body.x, self.body.y)
    end

    return Enemy
end

Entities.newPlayer = function()
    local Player = {
        health = 100,
        body = Physics.newBody(WIDTH / 2, HEIGHT / 2, 20.25),
        collider = Physics.newSphereCollider(WIDTH / 2, HEIGHT / 2, 25),
        firing = false,
        aimx = 0,
        aimy = 0,
        shootdelay = 0.2,
        lastshot = 0
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

        self.lastshot = self.lastshot + dt
        if self.lastshot > self.shootdelay then
            if love.keyboard.isDown("left") then
                self.firing = true
                self.aimx = -1
            end
            if love.keyboard.isDown("right") then
                self.firing = true
                self.aimx = 1
            end
            if love.keyboard.isDown("up") then
                self.firing = true
                self.aimy = -1
            end
            if love.keyboard.isDown("down") then
                self.firing = true
                self.aimy = 1
            end
            if self.firing then
                self.lastshot = 0
            end
        end

        -- Player Movement
        Player.body:integrate(dt, dirx, diry)
        Player.collider:updatePos(Player.body.x, Player.body.y)
    end

    function Player:keypressed(key)
        if self.lastshot > self.shootdelay then
            if key == "left" then
                self.firing = true
                self.aimx = -1
            end
            if key == "right" then
                self.firing = true
                self.aimx = 1
            end
            if key == "up" then
                self.firing = true
                self.aimy = -1
            end
            if key == "down" then
                self.firing = true
                self.aimy = 1
            end
            if self.firing then
                self.lastshot = 0
            end
        end
    end

    function Player:draw()
        love.graphics.setColor(.1, .43, .91)
        love.graphics.rectangle("fill", Player.body.x - 20, Player.body.y - 20, 40, 40)
    end

    return Player

end

return Entities