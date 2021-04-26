require("Objects/Player")
require("Objects/Ball")

function love.load()
    Player:load()
    Ball:load()
end

function love.update(dt)
    Player:update(dt)
    Ball:update(dt)
    quitGame()
end

function love.draw()
    Player:draw()
    Ball:draw()
end

function checkCollision(a, b)
    colliding = false
    if a.x < b.x + b.width and a.x+a.width > b.x and a.y < b.y + b.height and a.y + a.height > b.y then  
        colliding = true
    end
    return colliding
end

function quitGame()
    if love.keyboard.isDown('escape') then
		love.event.push('quit')
    end
end