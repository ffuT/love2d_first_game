local Physics ={
    newBody = function(x,y,a)
        local Body = {}
        Body.x = x
        Body.y = y
        Body.velx = 0
        Body.vely = 0
        Body.acc = a
        Body.maxSpeed = 3.116

        function Body:Intergrate(dt, dirx, diry)
            self.velx = self.velx + self.acc * dt * dirx
            self.vely = self.vely + self.acc * dt * diry

            if self.velx > self.maxSpeed then
                self.velx = self.maxSpeed
            end
            if self.vely > self.maxSpeed then
                self.vely = self.maxSpeed
            end
            if self.velx < -self.maxSpeed then
                self.velx = -self.maxSpeed 
            end
            if self.vely < -self.maxSpeed then
                self.vely = -self.maxSpeed 
            end

            self.x = self.x + self.velx * dt * 100
            self.y = self.y + self.vely * dt * 100
            
            if math.abs(self.velx) > 0.0114 * self.acc then 
                self.velx = self.velx - self.velx * dt * self.acc / 9
            else
                self.velx = 0
            end
            if math.abs(self.vely) > 0.0114 * self.acc then
                self.vely = self.vely - self.vely * dt * self.acc / 9
            else
                self.vely = 0
            end
        end
        return Body
    end,

    newSphereCollider = function(x, y, r)
        local Collider = {}
        Collider.x = x
        Collider.y = y
        Collider.r = r

        function Collider:updatePos(x, y)
            self.x = x
            self.y = y
        end

        function Collider:CheckCollision(other)
            local dx = other.x - self.x
            local dy = other.y - self.y
            local distanceSq = dx * dx + dy * dy
            local radiusSum = self.r + other.r
            if distanceSq <= radiusSum * radiusSum then
                return true
            end
            return false
        end
        return Collider
    end


}

return Physics;