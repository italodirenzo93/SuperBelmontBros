
local Map = {}
Map.__index = Map

function Map:new(path)
    local this = {}
    this.map = require(path)
    this.quads = {}
    this.tileset = this.map.tilesets[1]

    -- Generate quads
    local tileset = this.tileset
    this.image = love.graphics.newImage('images/' .. tileset.image)
    for y = 0, (tileset.imageheight / tileset.tileheight) - 1 do
        for x = 0, (tileset.imagewidth / tileset.tilewidth) -1 do
            local quad = love.graphics.newQuad(
                x * tileset.tilewidth,
                y * tileset.tileheight,
                tileset.tilewidth,
                tileset.tileheight,
                tileset.imagewidth,
                tileset.imageheight)
            table.insert(this.quads, quad)
        end
    end

    -- create a spritebatch
    this.spritebatch = love.graphics.newSpriteBatch(this.image, #this.quads)

    setmetatable(this, self)
    return this
end


function Map:draw()
    -- Iterate over each layer
    for i, layer in ipairs(self.map.layers) do

        if layer.visible then
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
    love.graphics.draw(self.spritebatch, 0, 0)
end

return Map