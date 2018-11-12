-- Module imports
local push = require 'push'
local Map = require 'map'

-- Screen vars
local windowWidth = 1280
local windowHeight = 720
local virtualWidth = 432
local virtualHeight = 243

-- Local vars
local map = nil

function love.load()
    map = Map:new('maps/tilemap')

    -- push:setupScreen(virtualWidth, virtualHeight, windowWidth, windowHeight, {
    --     fullscreen = false
    -- })
end


function love.update(dt)

end


function love.keypressed(key)
    if key == 'left' or key == 'a' then
        --love.graphics.translate()
    end
end


function love.draw()
    --push:start()
    map:draw()
    --push:finish()
end