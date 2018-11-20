-- Module imports
local Class = require 'libs/hump.class'
local Sprite = require 'sprite'
local Animation = require 'animation'

-- Class definition
local Player = Class{__includes = Sprite}

-- Constants
local GRAVITY = 240
local MAXXVELOCITY = 140
local MAXYVELOCITY = 140

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

    self.flipX = false
    self.flipY = false
    self.scaleX = 2
    self.scaleY = 2

    -- create bounding box for collision
    world:add(self, self:getX(), self:getY(), self.width * self.scaleX, self.height * self.scaleY)

    self.states = {
        idle = {
            animation = Animation{ love.graphics.newQuad(8, 0, self.width, self.height, texture:getDimensions()) },

            onupdate = function (state, dt)
                self.vx = 0
            end
        },

        walk = {
            animation = Animation({
                love.graphics.newQuad(8, 0, self.width, self.height, texture:getDimensions()),
                love.graphics.newQuad(50, 0, 12, 31, texture:getDimensions()),
                love.graphics.newQuad(88, 0, self.width, self.height, texture:getDimensions())
            }, 0.115),

            onupdate = function (state, dt)
                if love.keyboard.isDown('left') then
                    self.vx = -MAXXVELOCITY
                    self.flipX = true
                end
                if love.keyboard.isDown('right') then
                    self.vx = MAXXVELOCITY
                    self.flipX = false
                end
                state.animation:update(dt)
            end
        },

        jump = {
            animation = Animation{ love.graphics.newQuad(208, 4, 16, 23, texture:getDimensions()) },

            onenter = function (state)
                self.vy = -180
                self.isJumping = true
            end,

            onupdate = function (state, dt)
                if love.keyboard.isDown('left') then
                    self.vx = -MAXXVELOCITY
                end
                if love.keyboard.isDown('right') then
                    self.vx = MAXXVELOCITY
                end
            end,

            onleave = function (state)
                self.isJumping = false
            end
        },

        attack = {
            animation = Animation({
                love.graphics.newQuad(0, 41, 31, 30, texture:getDimensions()),
                love.graphics.newQuad(46, 40, 60, 30, texture:getDimensions())
            }, 0.115),

            onupdate = function (state, dt)
                state.animation:update(dt)
            end
        }
    }

    self.state = self.states['idle']
end

local function switchState(player, key)
    -- Leave the previous state
    if player.state.onleave ~= nil then
        player.state:onleave()
    end

    -- assign new state
    player.state = player.states[key]

    -- Enter the new state
    if player.state.onenter ~= nil then
        player.state:onenter()
    end
end

local function checkCollision(player, collision)
    local thisRect, otherRect = collision.itemRect, collision.otherRect
    -- Check if we landed on the ground
    if collision.other.type == 'Ground' and otherRect.y > thisRect.y + thisRect.h then
        switchState(player, 'idle')
    end
end

function Player:update(dt, world)
    -- Update state
    if self.state.onupdate ~= nil then
        self.state:onupdate(dt)
    end

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
        switchState(self, 'jump')
    elseif (key == 'left' or key == 'right') and not self.isJumping then
        switchState(self, 'walk')
    elseif key == 'z' then
        switchState(self, 'attack')
    end
end

function Player:keyreleased(key, scancode, isrepeat)
    if (key == 'left' or key == 'right') and not self.isJumping then
        switchState(self, 'idle')
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
        self.state.animation:getCurrentFrame(),  -- quad
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