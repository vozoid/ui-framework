requires isfile, writefile, readfile, makefolder, isfolder

example
```lua
local framework = loadstring(game:HttpGet("https://raw.githubusercontent.com/vozoid/ui-framework/main/module.lua"))()

local gui = Instance.new("ScreenGui", game.CoreGui)

local btn = Instance.new("Frame", gui)
btn.Size = UDim2.new(0, 50, 0, 50)
btn.Position = UDim2.new(0.2, 0, 0.2, 0)

local toggle = framework.toggle(btn)

toggle.Toggled:connect(function(bool) 
    btn.BackgroundTransparency = bool and 0.5 or 0
end)
```
