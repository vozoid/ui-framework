local gui = Instance.new("ScreenGui", game.CoreGui)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 50)
frame.Position = UDim2.new(0, 50, 0, 50)

local button = framework.button(frame)

button.clicked:connect(function()
    print("hi")
end)

button:click()
