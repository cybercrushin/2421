require("bootstrap")

function love.load()
    World:load()
    Player:load()
    Ball:load()
end

function love.update(dt)
    World:update(dt)
    Player:update(dt)
    Ball:update(dt)
    quitGame()
end

function love.draw()
    World:draw()
    Player:draw()
    Ball:draw()
    --love.graphics.draw(animation_atlas, hit_sprite, 100, 100)
end

function quitGame()
    if love.keyboard.isDown('escape') then
		love.event.push('quit')
    end
end