local Class = require 'libs/hump.class'

-- Class definition
local Animation = Class{}

function Animation:init(quads, frameTime)
    self.quads = quads or {}
    self.frameTime = frameTime or 0
    self.elapsed = 0
    self.currentFrame = 1
    self.isPlaying = true
end

function Animation:update(dt)
    if self.frameTime > 0 and self.isPlaying then
        self.elapsed = self.elapsed + dt
        if self.elapsed >= self.frameTime then
            self.elapsed = 0
            -- Next frame
            if self.currentFrame + 1 >= #self.quads then
                self.currentFrame = 1
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
end

function Animation:stop()
    self.isPlaying = false
    self.currentFrame = 1
end

return Animation
