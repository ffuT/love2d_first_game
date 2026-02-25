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
    b.collider.x, b.collider.y = x, y
    b.xv, b.yv = xv, yv
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
        b.collider.x = b.collider.x + 1200 * dt * b.xv
        b.collider.y = b.collider.y + 1200 * dt * b.yv
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