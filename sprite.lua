local Class = require 'libs/hump.class'

local Sprite =  Class{}

function Sprite:init(image, x, y)
    self.image = image or nil
    self.x = x or 0
    self.y = y or 0
    self.originX = 0
    self.originY = 0
    self.scaleX = 1
    self.scaleY = 1
end

function Sprite:draw()
    love.graphics.draw(self.image, self:getX(), self:getY())
end

function Sprite:getX()
    return self.x - self.originX * self.scaleX
end

function Sprite:getY()
    return self.y - self.originY * self.scaleY
end

function Sprite:setX(x)
    self.x = x + self.originX * self.scaleX
end

function Sprite:setY(y)
    self.y = y + self.originY * self.scaleY
end

return Sprite
