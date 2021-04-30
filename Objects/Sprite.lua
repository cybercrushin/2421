local Sprite = Object:extend()

function Sprite:new(img_path)
    self.sprite_atlas = love.graphics.newImage(img_path)
end

return Sprite