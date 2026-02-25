local Physics = require("Physics")

local Bullets = {
    BulletPool = {},
    BulletActive = {}
}

function Bullets:spawnBullet(x, y, xv, yv)
    local b = table.remove(self.BulletPool)
    if not b then
        b = {
            collider = Physics.newSphereCollider(x,y,5),
            damage = 10
        }
    end
    b.collider.x, b.collider.y = x + love.math.random(-5, 5), y + love.math.random(-5, 5)
    -- normalize bullet speed
    local len = math.sqrt(xv * xv + yv * yv)
    local speedScale = 0.85 + love.math.random(1,4) / 10 --random bullet speed
    b.xv = xv / len * speedScale
    b.yv = yv / len * speedScale
    table.insert(self.BulletActive, b)
end

function Bullets:killBullet(i)
    local b = self.BulletActive[i]
    self.BulletActive[i] = self.BulletActive[#self.BulletActive]
    self.BulletActive[#self.BulletActive] = nil
    table.insert(self.BulletPool, b)
end

function Bullets:update(dt, Enemylist)
    local pixelPerSecScale = 1000
    for i = #self.BulletActive, 1, -1 do
        local b = self.BulletActive[i]

        b.collider.x = b.collider.x + pixelPerSecScale * dt * b.xv
        b.collider.y = b.collider.y + pixelPerSecScale * dt * b.yv

        for j = #Enemylist, 1, -1 do
            if b.collider:CheckCollision(Enemylist[j].collider) then
                Enemylist[j]:takeDamage(b.damage)
                self:killBullet(i)
                goto continue
            end
        end
        if b.collider.x > WIDTH or b.collider.x < 0 or b.collider.y > HEIGHT or b.collider.y < 0 then
            self:killBullet(i)
        end
        ::continue::
    end
end

function Bullets:draw()
    for _, b in ipairs(self.BulletActive) do
        love.graphics.setColor(1, 1, 1)
        love.graphics.ellipse("fill", b.collider.x, b.collider.y, b.collider.r, b.collider.r);
    end
end

return Bullets