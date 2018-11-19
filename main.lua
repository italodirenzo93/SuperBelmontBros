-- Module imports
local Camera = require 'libs/hump.camera'
local bump = require 'libs/bump.bump'
local TiledMap = require 'tiledmap'
local Player = require 'player'

-- Constants
local DEBUG_COLLISIONS = false

function love.load()
    -- Preserve the NES "pixelated" look
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Init the collision system
    world = bump.newWorld()

    -- Load level
    map = TiledMap('maps/1-1', world)

    -- Load sprites
    local playerStart = map:getLayer('Player').objects[1]
    mario = Player(playerStart.x, playerStart.y, world)

    -- Init camera
    camera = Camera(mario:getX(), mario:getY(), 2)
end

function love.update(dt)
    mario:update(dt, world)

    -- Camera follows player
    local dx, dy = mario:getX() - camera.x, mario:getY() - camera.y
    camera:move(dx/2, dy/2)
end

function love.keypressed(key, scancode, isrepeat)
    mario:keypressed(key, scancode, isrepeat)
end

function love.draw()
    -- Set clear color to white
    love.graphics.setColor(1,1,1)

    -- Begin drawing
    camera:attach()

    -- Draw game
    map:draw()
    mario:draw()

    if DEBUG_COLLISIONS then
        -- Draw bounding boxes (debug)
        love.graphics.setColor(0,1,0)
        local items, len = world:getItems()
        for i = 1, len do
            local x, y, w, h = world:getRect(items[i])
            love.graphics.rectangle('line', x, y, w, h)
        end
    end

    -- Finish drawing
    camera:detach()

    -- UI
    love.graphics.setColor(1,1,1)
    local fps = love.timer.getFPS()
    love.graphics.print('FPS: ' .. fps, 0 , 0)
end

