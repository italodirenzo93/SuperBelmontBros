-- Module imports
local Class = require 'libs/hump.class'

-- Class definition
local TiledMap = Class{}

function TiledMap:init(path, world)
    self.map = require(path)
    self.quads = {}
    self.tileset = self.map.tilesets[1]

    -- Generate quads
    local tileset = self.tileset
    self.image = love.graphics.newImage('images/' .. tileset.image:match('^.+/(.+)$'))
    for y = 0, (tileset.imageheight / tileset.tileheight) - 1 do
        for x = 0, (tileset.imagewidth / tileset.tilewidth) -1 do
            local quad = love.graphics.newQuad(
                x * tileset.tilewidth,
                y * tileset.tileheight,
                tileset.tilewidth,
                tileset.tileheight,
                tileset.imagewidth,
                tileset.imageheight)
            table.insert(self.quads, quad)
        end
    end

    -- create a spritebatch
    self.spritebatch = love.graphics.newSpriteBatch(self.image, #self.quads)

    -- create static physics bodies
    local collisionLayer = self:getLayer('Collision')
    local shape, body, fixture
    for i, object in ipairs(collisionLayer) do
        if object.type == 'rectangle' then
            -- create rectangle shape
            shape = love.physics.newRectangleShape(object.width, object.height)

            -- create body
            body = love.physics.newBody(world, object.x, object.y, 'static')

            -- create fixture
            fixture = love.physics.newFixture(body, shape)
        end
    end

end


function TiledMap:draw()
    -- Set background color (normalize RGB values between 0-1)
    local r, g, b = unpack(self.map.backgroundcolor)
    local len = math.sqrt(r * r + g * g + b * b)
    love.graphics.setBackgroundColor(r / len, g / len, b / len)

    -- Clear out the contents of the spritebatch
    self.spritebatch:clear()

    -- Iterate over each layer and add the quads to the spritebatch
    for i, layer in ipairs(self.map.layers) do
        if layer.visible and layer.type == 'tilelayer' then
            -- Draw tiles
            for y = 0, layer.height - 1 do
                for x = 0, layer.width - 1 do
                    local index = (x + y * layer.width) + 1
                    local tid = layer.data[index]

                    -- 0 == transparent
                    if tid ~= 0 then
                        local quad = self.quads[tid]
                        local xx = x * self.tileset.tilewidth
                        local yy = y * self.tileset.tileheight
                        self.spritebatch:add(quad, xx, yy)
                    end -- if not transparent tile
                end -- x
            end -- y
        end -- visible
    end -- layer
    
    -- Draw the map
    love.graphics.draw(self.spritebatch, 0, 0)
end

function TiledMap:getLayer(name)
    for i, layer in ipairs(self.map.layers) do
        if layer.name == name then
            return layer
        end
    end
end

return TiledMap