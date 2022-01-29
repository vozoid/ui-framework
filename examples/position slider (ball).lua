local gui = Instance.new("ScreenGui", game.CoreGui)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 50)
frame.Position = UDim2.new(0, 50, 0, 50)

local ball = Instance.new("Frame", frame)
ball.Size = UDim2.new(0, 10, 1, 0)
ball.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

local slider = framework.positionslider(frame, ball, 0, 100, 0.1) -- slider, ball, min, max, tweenspeed (default 0)
slider:set(40)

slider.Updated:connect(function(value)
    print(value)
end)
