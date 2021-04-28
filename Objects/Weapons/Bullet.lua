Bullet = Object:extend()

function Bullet:new()
    self.x = 0
    self.y = 0
    self.img = nil
    self.height = 0
    self.width = 0
    self.dmg = 0
end

DefaultBullet = Bullet:extend()

function DefaultBullet:new(x, y)
    self.img = love.graphics.newImage('Assets/Player/default_bullet.png')
    self.x = x - self.img:getWidth() / 2
    self.y = y
    self.width = self.img:getHeight()
    self.height = self.img:getWidth()
    self.dmg = 500
end