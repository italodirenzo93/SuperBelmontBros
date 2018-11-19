-- Module imports
local Class = require 'libs/hump.class'
local Sprite = require 'sprite'
local Animation = require 'animation'

-- Class definition
local Player = Class{__includes = Sprite}

-- Constants
local GRAVITY = 170
local MAXXVELOCITY = 90
local MAXYVELOCITY = 25

function Player:init(x, y, world)
    local texture = love.graphics.newImage('images/sheet-simon.png')

    -- call superclass constructor
    Sprite.init(self, texture, x or 0, y or 0)

    self.name = 'Player'
    self.width = 16
    self.height = 31

    self.originX = self.width / 2
    self.originY = self.height / 2

    self.vx = 0
    self.vy = MAXYVELOCITY

    local animationFrames = {
        love.graphics.newQuad(8, 0, self.width, self.height, texture:getDimensions()),
        love.graphics.newQuad(50, 0, 12, 31, texture:getDimensions()),
        love.graphics.newQuad(88, 0, self.width, self.height, texture:getDimensions())
    }
    self.animations = {}
    self.animations['idle'] = Animation{animationFrames[1]}
    self.animations['walk'] = Animation(animationFrames, 0.115)
    self.animations['jump'] = Animation{love.graphics.newQuad(208, 4, 16, 23, texture:getDimensions())}

    self.animationKey = 'idle'

    self.flipX = false
    self.flipY = false
    self.scaleX = 2
    self.scaleY = 2

    -- create bounding box for collision
    world:add(self, self:getX(), self:getY(), self.width * self.scaleX, self.height * self.scaleY)
end

local function checkCollision(player, collision)
    if collision.other.type == 'Ground' then
        player.isJumping = false
    end
end

function Player:update(dt, world)
    if love.keyboard.isDown('left') then
        self.vx = -MAXXVELOCITY
        if not self.isJumping then self.flipX = true end
    elseif love.keyboard.isDown('right') then
        self.vx = MAXXVELOCITY
        if not self.isJumping then self.flipX = false end
    else
        self.vx = 0
    end

    -- update animation
    if self.isJumping then
        self.animationKey = 'jump'
    elseif self.vx ~= 0 then
        self.animationKey = 'walk'
    else
        self.animationKey = 'idle'
    end
    self.animations[self.animationKey]:update(dt)

    -- update position
    local goalX, goalY = self:getX() + self.vx * dt, self:getY() + self.vy * dt
    local actualX, actualY, cols, len = world:move(self, goalX, goalY)
    self:setX(actualX)
    self:setY(actualY)

    -- handle collisions
    for i = 1, len do
        checkCollision(self, cols[i])
    end

    -- apply downward force
    if self.vy < MAXYVELOCITY then
        self.vy = self.vy + GRAVITY * dt
    end
end

function Player:keypressed(key, scancode, isrepeat)
    if key == 'space' and not self.isJumping then
        -- jump
        self.vy = -100
        self.animationKey = 'jump'
        self.isJumping = true
    end
end

-- Override
function Player:draw()
    -- Check flip booleans
    local sx, sy = self.scaleX, self.scaleY
    if self.flipX then sx = -sx end
    if self.flipY then sy = -sy end

    love.graphics.setColor(1,1,1)
    love.graphics.draw(
        self.image,         -- drawable
        self.animations[self.animationKey]:getCurrentFrame(),  -- quad
        self.x,             -- x
        self.y,             -- y
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