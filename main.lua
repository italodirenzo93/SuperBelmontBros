-- Module imports
local push = require 'libs/push'
local Camera = require 'libs/hump.camera'
local TiledMap = require 'tiledmap'
local Player = require 'player'


function love.load()
    -- Preserve the NES "pixelated" look
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Set up physics
    world = love.physics.newWorld(0, 9.81)

    -- Load level
    map = TiledMap('maps/1-1', world)

    -- Load sprites
    local playerStart = map:getLayer('Player').objects[1]
    mario = Player(playerStart.x, playerStart.y, world)

    -- Init camera
    camera = Camera(mario:getX(), mario:getY(), 2)
end

function love.update(dt)
    world:update(dt)
    mario:update(dt)

    -- Camera follows player
    local dx, dy = mario.body:getX() - camera.x, mario.body:getY() - camera.y
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
