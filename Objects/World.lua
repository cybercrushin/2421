World = {}

function World:load()
    self.speed = 300
    self.xVel = 0
    self.yVel = self.speed
    local bg_img = love.graphics.newImage('Assets/World/spr_stars02.png')
    self.bg_imgs = {}
    
    self.bg_imgs[1] = {}
    self.bg_imgs[1]['image'] = bg_img
    self.bg_imgs[1]['y'] = 0
    self.bg_imgs[1]['x'] = 0
    self.bg_imgs[2] = {}
    self.bg_imgs[2]['image'] = bg_img
    self.bg_imgs[2]['y'] = self.bg_imgs[1]['y'] - self.bg_imgs[1]['image']:getHeight()
    self.bg_imgs[2]['x'] = 0
    self.reset_y = 0 - self.bg_imgs[1]['y'] - self.bg_imgs[1]['image']:getHeight()

end

function World:update(dt)
    if self.bg_imgs[1]['y'] >= love.graphics.getHeight() then
        self.bg_imgs[1]['y'] = self.reset_y
    end
    if self.bg_imgs[2]['y'] >= love.graphics.getHeight() then
        self.bg_imgs[2]['y'] = self.reset_y
    end

    -- self.bg_imgs[1]['x'] = self.bg_imgs[1]['x'] + self.xVel * dt
    self.bg_imgs[1]['y'] = self.bg_imgs[1]['y'] + self.yVel * dt
    -- self.bg_imgs[2]['x'] = self.bg_imgs[2]['x']  + self.xVel * dt
     self.bg_imgs[2]['y'] = self.bg_imgs[2]['y']  + self.yVel * dt

end

function World:draw()
    love.graphics.draw(self.bg_imgs[1]['image'], self.bg_imgs[1]['x'], self.bg_imgs[1]['y'])
    love.graphics.draw(self.bg_imgs[2]['image'], self.bg_imgs[2]['x'], self.bg_imgs[2]['y'])
end

