-- Module imports
local push = require 'libs/push'
local Camera = require 'libs/hump.camera'
local TiledMap = require 'tiledmap'
local Player = require 'player'

-- Local vars
local map = nil
local mario = nil
local camera = nil

function love.load()
    -- Preserve the NES "pixelated" look
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Load sprites
    mario = Player(50, 140)

    -- Load level
    map = TiledMap('maps/1-1')

    -- Init camera
    camera = Camera(mario:getX(), mario:getY(), 2)
end

function love.update(dt)
    mario:update(dt)

    -- Camera follows player
    local dx, dy = mario:getX() - camera.x, mario:getY() - camera.y
    camera:move(dx/2, dy/2)
end

function love.draw()
    -- Begin drawing
    camera:attach()

    -- Draw game
    map:draw()
    mario:draw()
    
    -- Finish drawing
    camera:detach()

    -- UI
    local fps = love.timer.getFPS()
    love.graphics.print('FPS: ' .. fps, 0 , 0)
end
