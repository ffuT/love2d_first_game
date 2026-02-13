local Physics = require("Physics")

local Entities = {
    newEnemy = function(x, y, health) 
        local Enemy = {}
        Enemy.body = Physics.newBody(x, y, 5)
        Enemy.radius = 10
        Enemy.collider = Physics.newSphereCollider(x, y, Enemy.radius)
        Enemy.health = health

            function Enemy:draw()
                love.graphics.setColor(0.9, 0.1, 0.1)
                love.graphics.ellipse("fill", self.body.x, self.body.y, self.radius, self.radius);
            end

            function Enemy:update(dt, targetx, targety)
                -- test dirs

                local dirx = targetx - self.body.x
                local diry = targety - self.body.y

                dirx = math.max(-1, math.min(1, dirx/2))
                diry = math.max(-1, math.min(1, diry/2))

                self.body:Intergrate(dt, dirx, diry)
                -- other stuff

                self.collider:updatePos(self.body.x, self.body.y)
            end

        return Enemy   
    end
}

return Entities
