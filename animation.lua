local Class = require 'libs/hump.class'

-- Class definition
local Animation = Class{}

function Animation:init(quads, frameTime, loop)
    self.quads = quads or {}
    self.frameTime = frameTime or 0
    self.elapsed = 0
    self.currentFrame = 1
    self.loop = loop or false
end

function Animation:update(dt)
    if self.frameTime > 0 and self.isPlaying then
        self.elapsed = self.elapsed + dt
        if self.elapsed >= self.frameTime then
            self.elapsed = 0
            -- Next frame
            if self.currentFrame + 1 > #self.quads then
                if self.loop then
                    -- start over again from the first frame
                    self.currentFrame = 1
                    if self.onloop ~= nil then
                        self:onloop()
                    end
                else
                    -- end the animation
                    self:stop()
                end
            else
                self.currentFrame = self.currentFrame + 1
            end
        end
    end
end

function Animation:getCurrentFrame()
    return self.quads[self.currentFrame]
end

function Animation:play()
    self.isPlaying = true
    -- invoke the callback function if one exists
    if self.onanimationstart ~= nil then
        self:onanimationstart()
    end
end

function Animation:stop()
    self.isPlaying = false
    self.currentFrame = 1
    -- invoke the callback function if one exists
    if self.onanimationend ~= nil then
        self:onanimationend()
    end
end

return Animation
