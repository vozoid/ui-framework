requires isfile, writefile, readfile, makefolder, isfolder

example
```lua
local framework = loadstring(game:HttpGet("https://raw.githubusercontent.com/vozoid/ui-framework/main/module.lua"))()

local gui = Instance.new("ScreenGui", game.CoreGui)

local slider = Instance.new("Frame", gui)
slider.Size = UDim2.new(0, 200, 0, 50)
slider.Position = UDim2.new(0.2, 0, 0.2, 0)
slider.Parent = gui

local ball = Instance.new("Frame", gui)
ball.Size = UDim2.new(0, 10, 1, 0)
ball.Position = UDim2.new(0, 0, 0, 0)
ball.Parent = slider
ball.BackgroundColor3 = Color3.fromRGB(255, 255, 255)


local sliderfunc = framework.positionslider(btn, btn2, 0, 30, 0.1)

sliderfunc.updated:connect(function(val) 
    print(val)
end)

sliderfunc:set(20)
```
