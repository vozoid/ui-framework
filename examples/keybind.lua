local gui = Instance.new("ScreenGui", game.CoreGui)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 50, 0, 50)
frame.Position = UDim2.new(0, 50, 0, 50)

local key = framework.Keybind(frame, {Enum.KeyCode.A}) -- keybind, blacklist table

key.Updated:connect(function(key)
    print(key)
end)

key.Pressed:connect(function()
    print("hi")
end)

key:set(Enum.KeyCode.R)
