Player = {}

function Player:load()
    -- Size Params
    self.width = 100
    self.height = 100
    self.weight = 100

    -- Speed / Movement Params
    self.speed = 400
    self.speed_modifier = 1.5

    -- Position Params
    self.x = 50
    self.y = love.graphics.getHeight() / 2 - self.height / 2
    self.direction = "up"

    -- Assets
    self.playerImg = love.graphics.newImage('Assets/Player/plane.png')

    -- Actions
    self.ifames = 5


    -- Booleans
    self.can_fire = true
    self.is_firing = false
    self.taking_damage = false
    self.is_dodging = false
    self.can_accept_input = true

    -- Weapons
    self.selected_weapon = 'default'
    self.weapons = {}
    self.weapons['default'] = {}
    self.weapons['default']['image'] = love.graphics.newImage('Assets/Player/default_bullet.png')
    self.weapons['default']['cooldown_total_time'] = .25
    self.weapons['default']['cooldown_val'] = self.weapons['default']['cooldown_total_time'] 

    -- Player Actions
    self.actions = {}
    self.actions['fire'] = function(dt)
        self:action(dt, 'move')
    end
    
    -- Player Bullet Objects
    self.bullets = {}
end

function Player:update(dt)
    self:move(dt)
    self:weaponAction(dt)
    self:moveBullets(dt)
    --self:actions:fire(dt)
    self:checkBoundaries()
end

-- Handles player movement 
function Player:move(dt)
    if self.can_accept_input then
        if love.keyboard.isDown("lshift") then
            calculated_speed = self.speed * self.speed_modifier * dt
        else 
            calculated_speed = self.speed * dt
        end

        if love.keyboard.isDown("w", "up") then
            self.y = self.y - calculated_speed
            self.direction = "up"
        elseif love.keyboard.isDown("s", "down") then
            self.y = self.y + calculated_speed
            self.direction = "down"
        elseif love.keyboard.isDown("a", "left") then
            self.x = self.x - calculated_speed
            self.direction = "left"
        elseif love.keyboard.isDown("d", "right") then
            self.x = self.x + calculated_speed
            self.diection = "right"
        end
    end
end

-- Function that exexcutes generic player action
function Player:action(dt, action_name)
    if nil ~= self.actions[action_name] then
        self.actions[action_name](dt)
    end

end

-- Class method handles the actions on the players selected weapon
function Player:weaponAction(dt)
    selected = self.selected_weapon
    -- check selected weapon cool down period
    self.weapons[selected]['cooldown_val'] = dt + self.weapons[selected]['cooldown_val']

    -- if enough time has passed from the last shot, allow the next shot to occur
    if self.weapons[selected]['cooldown_val'] >= self.weapons[selected]['cooldown_total_time'] then
        self.weapons[selected]['cooldown_val'] = self.weapons[selected]['cooldown_total_time']
        self.can_fire = true
    else
        self.can_fire = false
    end

    -- if the user has hit an input to fire a weapon and cooldown has occured, add the bullet object to game
    if love.keyboard.isDown('space', 'rctrl', 'lctrl') and self.can_fire then    
        newBullet = { x = self.x + (self.playerImg:getWidth()/2), y = self.y - 10, img = self.weapons[selected]['image'] }
        table.insert(self.bullets, newBullet)
        self.weapons[selected]['cooldown_val'] = 0
    end

end

-- This moves any active bullets across the screen
function Player:moveBullets(dt)
    for i, bullet in ipairs(self.bullets) do
        bullet.y = bullet.y - (250 * dt)
    
          if bullet.y < 0 then -- remove bullets when the   y pass off the screen
            table.remove(self.bullets, i)
        end
    end
    
end

-- Checks to make sure the player is within the allowed boundaries of the game
function Player:checkBoundaries(dt)
    screen_height = love.graphics.getHeight()
    screen_width = love.graphics.getWidth()
    if self.y <= 0 then
        self.y = 0
    elseif self.y + self.height >= screen_height then
        self.y = screen_height - self.height
    end

    if self.x <= 0 then
        self.x = 0
    elseif self.x + self.width >= screen_width  then
        self.x = screen_width - self.height
    end
end

-- Draw all player related assets
function Player:draw()
    self:drawPlayer(dt)    
    self:drawBullets(dt)
end

-- Draw the player sprite
function Player:drawPlayer()
    love.graphics.draw(self.playerImg, self.x, self.y)
end

-- Draw the characters bullets if any
function Player:drawBullets()
    for i, bullet in ipairs(self.bullets) do
        love.graphics.draw(bullet.img, bullet.x, bullet.y)
    end
end
 