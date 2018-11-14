local Class = require 'libs/hump.class'

return Class{
    init = function (self, image, x, y)
        self.image = image or nil
        self.x = x or 0
        self.y = y or 0
        self.originX = 0
        self.originY = 0
    end,

    draw = function (self)
        love.graphics.draw(self.image, self.x - self.originX, self.y - self.originY)
    end
}
