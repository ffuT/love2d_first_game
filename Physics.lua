local Physics ={
    newBody = function(x,y,a)
        local Body = {}
        Body.x = x
        Body.y = y
        Body.velx = 0
        Body.vely = 0
        Body.acc = a

        function Body:Intergrate(dt, dirx, diry)
            self.velx = self.velx + self.acc * dt * dirx
            self.vely = self.vely + self.acc * dt * diry

            local speed = self.velx + self.vely
            local maxspeed = 2.316

            -- TODO fix cap diag movespeed

            if self.velx > maxspeed then
                self.velx = maxspeed
            end
            if self.vely > maxspeed then
                self.vely = maxspeed
            end
            if self.velx < -maxspeed then
                self.velx = -maxspeed 
            end
            if self.vely < -maxspeed then
                self.vely = -maxspeed 
            end

            self.x = self.x + self.velx * dt * 100
            self.y = self.y + self.vely * dt * 100

        end
        return Body
    end

}

return Physics;