Ball = {}


function Ball:load()
    self.width = 20
    self.height = 20
    self.speed = 300
    self.xVel = -self.speed
    self.yVel = 0
    self.radius = 20
    self.x = love.graphics.getWidth() / 2 
    self.y = love.graphics.getHeight() / 2 
    
    
end

function Ball:update(dt)
    self:move(dt)
    self:collide()
    self:checkBoundaries()
end

function Ball:move(dt)
    self.x = self.x + self.xVel * dt
    self.y = self.y + self.yVel * dt
end

function Ball:collide()
    if checkCollision(self, Player) then 
        self.xVel = self.speed
        local middleBall = self.y + self.height / 2
        local middlePlayer = Player.y + Player.height / 2
        local collisionPosition = middleBall - middlePlayer
        self.yVel = collisionPosition * 5
    end
    if self.y <= 0 then
        -- self.y = 0
        self.yVel = -self.yVel
    elseif self.y + self.height >= love.graphics.getHeight() then
        --self.y = love.graphics.getHeight() - self.height
        self.yVel = -self.yVel
    end
    -- if ball hits left or right bounce back
    if self.x <= 0 then
        self.xVel = -self.xVel
    elseif self.x + self.width >= love.graphics.getWidth() then
        self.xVel = -self.xVel
    end
    

end


function Ball:checkBoundaries(dt)
    
    -- screen_height = love.graphics.getHeight()
    -- -- if ball's hits the top then bounce down
    -- if self.y <= 0 then
    --     self.y = 0
    --     self.yVel = -self.yVel
    -- -- if ball hits the bottom then bounce up
    -- elseif self.y + self.height >= screen_height then
    --     self.y = screen_height - self.height
    --     self.yVel = -self.yVel
    -- end
    -- -- if ball hits the left warp it to the right side
    -- if self.x == 0 - self.width then 
    --     self.x = love.graphics.getWidth() + self.width
    -- end
end

function Ball:draw()
    love.graphics.circle("fill", self.x, self.y, self.radius)
    --love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end