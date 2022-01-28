local framework = loadstring(readfile("ui-framework/modules/framework.lua"))()
local inputService = game:GetService("UserInputService")

function PositionSlider(slider, ball, min, max, tweenInfo)
    local min = min or 1
    local max = max or 100
    local tweenInfo = tweenInfo or {0}

    if typeof(tweenInfo) == "number" then
        tweenInfo = {tweenInfo}
    end

    local sliderTypes = {
        Updated = framework.signal.new()
    }

    sliderTypes = framework.format_table(sliderTypes)

    local function slide(input)
        local sizeX = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
        local posX = math.clamp(sizeX * slider.AbsoluteSize.X, 0, slider.AbsoluteSize.X - ball.AbsoluteSize.X)
        local valX = posX / (slider.AbsoluteSize.X - ball.AbsoluteSize.X)
        
        framework.tween(ball, tweenInfo, {Position = UDim2.new(0, posX, 0, 0)})

        local value = math.floor((((max - min) * valX) + min))

        sliderTypes.Updated:Fire(value)
    end

    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = true
            slide(input)
        end
    end)

    slider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = false
        end
    end)

    inputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if sliding then
                slide(input)
            end
        end
    end)

    function sliderTypes:Set(value)
        value = math.floor(value)
        value = math.clamp(value, min, max)

        local posX = math.clamp((value - min) / (max - min) * slider.AbsoluteSize.X, 0, slider.AbsoluteSize.X - ball.AbsoluteSize.X)

        ball.Position = UDim2.new(0, posX, 0, 0)

        sliderTypes.Updated:Fire(value)
    end

    return sliderTypes
end

return PositionSlider
