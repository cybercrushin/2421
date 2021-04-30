Player = {}

function Player:load()
    -- Size Params
    self.width = 87
    self.height = 80
    self.weight = 100

    -- Speed / Movement Params
    self.speed = 400
    self.speed_modifier = 1.5

    -- Position Params
    self.x = love.graphics.getWidth() / 2 - (self.width / 2)
    self.y = love.graphics.getHeight() - self.height - 10
    self.direction = "up"

    -- Assets
    -- self.neutralImage = love.graphics.newImage('Assets/Player/ship0.png')
    -- self.leftImage = love.graphics.newImage('Assets/Player/ship-1.png')
    -- self.rightImage = love.graphics.newImage('Assets/Player/ship1.png')
    -- self.playerImg = self.neutralImage
    self.sprite = LoveAnimation.new('Sprites/player_ship.lua')
    self.sprite_max_directional_frames = 4
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
    self.weapons['default']['bullet'] = DefaultBullet
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
    self.sprite:update(dt)
    self:weaponAction(dt)
    self:updateBullets(dt)
    self:checkBoundaries()
end

function Player:changeDirection(direction)
    local currentState = self.sprite:getCurrentState()
    if currentState ~= direction then
        self.sprite:unpause()
        self.sprite:setState(direction)
    elseif currentState == direction and self.sprite.currentFrame == self.sprite_max_directional_frames then
        self.sprite:pause()
    end

end

-- Handles player movement 
function Player:move(dt)
    if self.can_accept_input then
        if love.keyboard.isDown("lshift") then
            calculated_speed = self.speed * self.speed_modifier * dt
        else 
            calculated_speed = self.speed * dt
        end
        local skip_up = false
        local skip_down = false
        -- move up / diagonally
        if love.keyboard.isDown("w", "up") and love.keyboard.isDown("a", "left") then
            self.y = self.y - calculated_speed
            self.x = self.x - calculated_speed
            self.direction = "up_left"
            -- self.playerImg = self.leftImage
            self:changeDirection('left')
            skip_up = true
        elseif love.keyboard.isDown("w", "up") and love.keyboard.isDown("d", "right") then
            self.y = self.y - calculated_speed
            self.x = self.x + calculated_speed
            self.direction = "up_right"
            -- self.playerImg = self.rightImage
            self:changeDirection('right')
            skip_up = true
        elseif love.keyboard.isDown("w", "up") and not skip_up then
            self.y = self.y - calculated_speed
            self.direction = "up"
            -- move down / diagonally
        elseif love.keyboard.isDown("s", "down") and love.keyboard.isDown("a", "left") then
            self.y = self.y + calculated_speed
            self.x = self.x - calculated_speed
            self.direction = "down_left"
            -- self.playerImg = self.leftImage
            self:changeDirection('left')
            skip_down = true
        elseif love.keyboard.isDown("s", "down") and love.keyboard.isDown("d", "right") then
            self.y = self.y + calculated_speed
            self.x = self.x + calculated_speed
            self.direction = "down_right"
            self:changeDirection('right')
            -- self.playerImg = self.rightImage
            skip_down = true
        elseif love.keyboard.isDown("s", "down") then
            self.y = self.y + calculated_speed
            self.direction = "down"

        -- move left or right
        elseif love.keyboard.isDown("a", "left") then
            self.x = self.x - calculated_speed
            self.direction = "left"
            self:changeDirection('left')
            -- self.playerImg = self.leftImage
        elseif love.keyboard.isDown("d", "right") then
            self.x = self.x + calculated_speed
            self.diection = "right"
            self:changeDirection('right')
            --self.playerImg = self.rightImage
        else
            self.sprite:setState('neutral')
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
        newBullet = self.weapons[selected]['bullet'](self.x + self.width / 2, self.y - 10)
        table.insert(self.bullets, newBullet)
        self.weapons[selected]['cooldown_val'] = 0
    end

end

-- This moves any active bullets across the screen
function Player:updateBullets(dt)
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
    elseif self.y + self.height > screen_height then
        self.y = screen_height - self.height - 1
    end

    if self.x < 0 then
        self.x = 0
    elseif self.x + self.width > screen_width then
        self.x = screen_width - self.width - 1
    end
end

-- Draw all player related assets
function Player:draw()
    self:drawPlayer(dt)    
    self:drawBullets(dt)
end

-- Draw the player sprite
function Player:drawPlayer()
    self.sprite:setPosition(self.x, self.y)
    self.sprite:draw()
end

-- Draw the characters bullets if any
function Player:drawBullets()
    for i, bullet in ipairs(self.bullets) do
        love.graphics.draw(bullet.img, bullet.x, bullet.y)
    end
end
 