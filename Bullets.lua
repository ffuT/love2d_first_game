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
    b.xv, b.yv = xv , yv
    b.speedScale = 0.85 + love.math.random(1,4) / 10 --random bullet speed
    b.alive = true
    table.insert(self.BulletActive, b)
end

function Bullets:killBullet(i)
    local b = self.BulletActive[i]
    b.alive = false
    self.BulletActive[i] = self.BulletActive[#self.BulletActive]
    self.BulletActive[#self.BulletActive] = nil
    table.insert(self.BulletPool, b)
end

function Bullets:update(dt, Enemylist)
    for i = #self.BulletActive, 1, -1 do
        local b = self.BulletActive[i]

        -- normalize bullet speed
        local len = math.sqrt(b.xv * b.xv + b.yv * b.yv)
        b.xv = b.xv / len * b.speedScale
        b.yv = b.yv / len * b.speedScale

        b.collider.x = b.collider.x + 1000 * dt * b.xv
        b.collider.y = b.collider.y + 1000 * dt * b.yv
        if b.collider.x > WIDTH or b.collider.x < 0 or b.collider.y > HEIGHT or b.collider.y < 0 then
            self:killBullet(i)
            goto continue
        end
        for j = #Enemylist, 1, -1 do
            if b.collider:CheckCollision(Enemylist[j].collider) then
                Enemylist[j]:takeDamage(b.damage)
                self:killBullet(i)
                goto continue
            end
        end
        ::continue::
    end
end

function Bullets:draw()
    for _, bullet in ipairs(self.BulletActive) do
        love.graphics.setColor(1, 1, 1)
        love.graphics.ellipse("fill", bullet.collider.x, bullet.collider.y, bullet.collider.r, bullet.collider.r);
    end
end

return Bullets