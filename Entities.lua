local Physics = require("Physics")

local Entities = {
    newEnemy = function(x, y, health) 
        local Enemy = {}
        Enemy.body = Physics.newBody(x, y, 5)
        Enemy.health = health

            function Enemy:draw()
                love.graphics.setColor(0.9, 0.1, 0.1)
                love.graphics.ellipse("fill", self.body.x, self.body.y, 10, 10);
            end

            function Enemy:update(dt, targetx, targety)
                -- test dirs

                local dirx = targetx - self.body.x
                local diry = targety - self.body.y

                dirx = math.max(-1, math.min(1, dirx/2))
                diry = math.max(-1, math.min(1, diry/2))

                self.body:Intergrate(dt, dirx, diry)
                -- other stuff
            end

        return Enemy   
    end
}

return Entities
