local gui = Instance.new("ScreenGui", game.CoreGui)

local box = Instance.new("TextBox", gui)
box.Size = UDim2.new(0, 200, 0, 50)
box.Position = UDim2.new(0, 50, 0, 50)

local box = framework.box(box)

box.Updated:connect(function(value)
    print(value)
end)

box:Set("hello")
