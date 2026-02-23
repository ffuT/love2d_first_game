local Physics = require("Physics")

local Entities = {
    newEnemy = function(x, y, health) 
        local Enemy = {}
        Enemy.body = Physics.newBody(x, y, 13.20)
        Enemy.radius = 15
        Enemy.collider = Physics.newSphereCollider(x, y, Enemy.radius)
        Enemy.health = health

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
            self.body:Intergrate(dt, predictiondirx, predictiondiry)
            -- update collision sphere
            self.collider:updatePos(self.body.x, self.body.y)
        end
        return Enemy   
    end
}

return Entities
