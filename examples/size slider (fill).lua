local gui = Instance.new("ScreenGui", game.CoreGui)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 50)
frame.Position = UDim2.new(0, 50, 0, 50)

local fill = Instance.new("Frame", frame)
fill.Size = UDim2.new(0, 0, 1, 0)
fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

local slider = framework.sizeslider(frame, fill, 0, 100, 0.1) -- slider, fill, min, max, tweenspeed (default 0)
slider:set(40)

slider.Updated:connect(function(value)
    print(value)
end)
