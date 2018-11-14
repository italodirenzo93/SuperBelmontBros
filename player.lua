local Class = require 'libs/hump.class'
local Sprite = require 'sprite'

-- Class definition
local Player = Class{__includes = Sprite}

function Player:init(x, y)
    local texture = love.graphics.newImage('images/mario1.png')
    Sprite.init(self, texture, x or 0, y or 0)
    self.speed = 210
end

function Player:update(dt)
    if love.keyboard.isDown('left') then
        self.x = self.x - self.speed * dt
    end
    if love.keyboard.isDown('right') then
        self.x = self.x + self.speed * dt
    end
end

-- Export class
return Player