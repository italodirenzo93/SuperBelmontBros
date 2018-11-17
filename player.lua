-- Module imports
local Class = require 'libs/hump.class'
local Sprite = require 'sprite'
local Animation = require 'animation'

-- Class definition
local Player = Class{__includes = Sprite}

function Player:init(x, y, world)
    local texture = love.graphics.newImage('images/mario1.png')

    -- call superclass constructor
    Sprite.init(self, texture, x or 0, y or 0)

    self.width = 16
    self.height = 32

    self.originX = self.width / 2
    self.originY = self.height / 2

    self.speed = 140

    local animationFrames = {
        love.graphics.newQuad(0, 0, self.width, self.height, texture:getDimensions()),
        love.graphics.newQuad(16 + 2, 0, self.width, self.height, texture:getDimensions()),
        love.graphics.newQuad(32 + 2, 0, self.width, self.height, texture:getDimensions()),
        love.graphics.newQuad(48 + 2, 0, self.width, self.height, texture:getDimensions())
    }
    self.animations = {}
    self.animations['idle'] = Animation({animationFrames[1]}, 1, 1)
    self.animations['walk'] = Animation(animationFrames, 15, 1)

    self.animationKey = 'idle'

    self.flipX = false
    self.flipY = false

    -- set up physics body
    local shape = love.physics.newRectangleShape(self.width, self.height)
    local body = love.physics.newBody(world, self.x, self.y, 'dynamic')
    local fixture = love.physics.newFixture(body, shape)
    self.body = body
end

function Player:update(dt)
    if love.keyboard.isDown('left') then
        self.x = self.x - self.speed * dt
        self.flipX = true
        self.animationKey = 'walk'
    elseif love.keyboard.isDown('right') then
        self.x = self.x + self.speed * dt
        self.flipX = false
        self.animationKey = 'walk'
    else
        self.animationKey = 'idle'
    end

    self.animations[self.animationKey]:update(dt)
end

-- Override
function Player:draw()
    -- Set scale factor based on flipp booleans
    local sx, sy = 1, 1
    if self.flipX then sx = -1 end
    if self.flipY then sy = -1 end

    love.graphics.draw(
        self.image,         -- drawable
        self.animations[self.animationKey]:getCurrentFrame(),  -- quad
        self.body:getX(),             -- x
        self.body:getY(),             -- y
        0,                  -- rotation
        sx,                 -- scale x
        sy,                  -- scale y,
        self.originX,       -- origin x
        self.originY,       -- origin y
        0,                  -- shear x
        0                   -- shear y
    )
end

-- Export class
return Player