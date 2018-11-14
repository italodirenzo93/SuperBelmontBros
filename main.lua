-- Module imports
local push = require 'libs/push'
local TiledMap = require 'tiledmap'
local Sprite = require 'sprite'

-- Screen vars
local windowWidth, windowHeight = love.graphics.getDimensions()
local virtualWidth = 432
local virtualHeight = 243

-- Local vars
local map = nil
local mario = nil

function love.load()
    -- Preserve the NES "pixelated" look
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Load sprites
    local texture = love.graphics.newImage('images/mario1.png')
    mario = Sprite(texture, 0, 0)

    -- Load level
    map = TiledMap('maps/1-1')

    -- Set up virtual screen resolution
    push:setupScreen(virtualWidth, virtualHeight, windowWidth, windowHeight, {
        fullscreen = false
    })
end

function love.update(dt)

end

function love.keypressed(key)

end

function love.draw()
    push:start()

    -- Draw game
    map:draw(virtualWidth, virtualHeight)
    mario:draw()
    
    push:finish()
end