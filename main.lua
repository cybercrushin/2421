Object = require "classic"
require("Objects/Player")
require("Objects/Ball")
require("Objects/World")
require("Objects/Weapons/Bullet")
require("Objects/External/love-animation/animation")
require("utils")

local animation_atlas
local hit_sprite
local anim = LoveAnimation.new('Sprites/default_hit.lua')
-- local blah = require('../../../../Sprites/default_hit')
print(blah)
function love.load()
    -- animation_atlas = love.graphics.newImage('Assets/World/explosions.png')
    --x 375, y 190
    -- hit_sprite = love.graphics.newQuad(375, 190, 32, 32, 224, animation_atlas:getDimensions())

    World:load()
    Player:load()
    Ball:load()
end

function love.update(dt)
    
    World:update(dt)
    Player:update(dt)
    Ball:update(dt)
    anim:update(dt)
    quitGame()
end

function love.draw()
    World:draw()
    Player:draw()
    Ball:draw()
    anim:draw()
    --love.graphics.draw(animation_atlas, hit_sprite, 100, 100)
end

function quitGame()
    if love.keyboard.isDown('escape') then
		love.event.push('quit')
    end
end