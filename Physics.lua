local Physics ={
    newBody = function(x,y,a)
        local Body = {}
        Body.x = x
        Body.y = y
        Body.velx = 0
        Body.vely = 0
        Body.acc = a
        Body.maxSpeed = 3.716

        function Body:integrate(dt, dirx, diry)

            -- normalize directions
            local len = math.sqrt(dirx * dirx + diry * diry)
            if len > 1 then
                dirx = dirx / len
                diry = diry / len
            end

            self.velx = self.velx + self.acc * dt * dirx
            self.vely = self.vely + self.acc * dt * diry

            local vellen = math.sqrt(self.velx * self.velx + self.vely * self.vely)
            if vellen > self.maxSpeed then
                self.velx = self.velx / (vellen / self.maxSpeed)
                self.vely = self.vely / (vellen / self.maxSpeed)
            end

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

            if math.abs(dirx) <= 0 then -- ignore friction when moving
                if math.abs(self.velx) > 0.0514 * self.acc * dt then
                    self.velx = self.velx - self.velx * dt * self.acc / 9
                else
                    self.velx = 0
                end
            end
            if math.abs(diry) <= 0 then -- same for y-axis
                if math.abs(self.vely) > 0.0514 * self.acc * dt then
                    self.vely = self.vely - self.vely * dt * self.acc / 9
                else
                    self.vely = 0
                end
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