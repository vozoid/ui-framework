local inputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local coreGui = game:GetService("CoreGui")

local Signal = loadstring(game:HttpGet("https://raw.githubusercontent.com/vozoid/Signal-library/main/main.lua"))()

local utility = {}

function utility.format_table(tbl)
    if tbl then
        local oldtbl = tbl
        local newtbl = {}
        local formattedtbl = {}

        for option, v in next, oldtbl do
            newtbl[option:lower()] = v
        end

        setmetatable(formattedtbl, {
            __newindex = function(t, k, v)
                rawset(newtbl, k:lower(), v)
            end,
            __index = function(t, k, v)
                return newtbl[k:lower()]
            end
        })

        return formattedtbl
    else
        return {}
    end
end

local framework = {}
framework = utility.format_table(framework)

framework.forcedProperties = {}

function framework:Create(object)
    local object = Instance.new(class)

    for prop, v in next, properties do
        object[prop] = v
    end

    for prop, v in next, framework.forcedProperties do
        pcall(function()
            object[prop] = v
        end)
    end
    
    return obj
end

function framework:Tween(obj, info, properties, callback)
    local anim = tweenService:Create(obj, TweenInfo.new(unpack(info)), properties)
    anim:Play()

    if callback then
        anim.Completed:Connect(callback)
    end
end

function framework:Dragify(object, speed)
    local start, objectPosition, dragging

    speed = speed or 0

    object.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            start = input.Position
            objectPosition = object.Position
        end
    end)

    object.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then 
            dragging = false
        end
    end)

    inputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then   
            framework:Tween(object, {speed}, {Position = UDim2.new(objectPosition.X.Scale, objectPosition.X.Offset + (input.Position - start).X, objectPosition.Y.Scale, objectPosition.Y.Offset + (input.Position - start).Y)})
        end
    end)
end

function framework:Button(object)
    local buttonTypes = {
        Clicked = Signal.new()
    }

    buttonTypes = utility.format_table(buttonTypes)

    object.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            buttonTypes.Clicked:Fire()
        end
    end)

    function buttonTypes:Click()
        buttonTypes.Clicked:Fire()
    end

    return buttonTypes
end

function framework:Toggle(object)
    local toggled = false

    local toggleTypes = {
        Toggled = Signal.new(), 
        Enabled = Signal.new(), 
        Disabled = Signal.new()
    }

    toggleTypes = utility.format_table(toggleTypes)

    local function toggle()
        toggled = not toggled
        toggleTypes.Toggled:Fire(toggled)

        if toggled then
            toggleTypes.Enabled:Fire(toggled)
        else
            toggleTypes.Disabled:Fire(toggled)
        end
    end

    object.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggle()
        end
    end)

    function toggleTypes:Toggle(bool)
        if toggled ~= bool then
            toggle()
        end
    end

    return toggleTypes
end

function framework:Box(object)
    local boxTypes = {
        Updated = Signal.new()
    }

    boxTypes = utility.format_table(boxTypes)

    local function updateBox()
        boxTypes.Updated:Fire(object.Text)
    end

    object.FocusLost:Connect(updateBox)

    function boxTypes:Set(text)
        object.Text = text
        updateBox()
    end

    return boxTypes
end

function framework:SizeSlider(slider, fill, min, max, tweenInfo)
    local min = min or 1
    local max = max or 100
    local tweenInfo = tweenInfo or {0}

    if typeof(tweenInfo) == "number" then
        tweenInfo = {tweenInfo}
    end

    local sliderTypes = {
        Updated = Signal.new()
    }

    sliderTypes = utility.format_table(sliderTypes)

    local function slide(input)
        local sizeX = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
        framework:Tween(fill, tweenInfo, {Size = UDim2.new(sizeX, 0, 1, 0)})

        local value = math.floor((((max - min) * sizeX) + min))

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
        value = math.floor(value * (decimals * 10)) / (decimals * 10)
        value = math.clamp(value, min, max)

        fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
        title.Text = name .. ": " .. value .. valueType
    end

    return sliderTypes
end

function framework:PositionSlider(slider, ball, min, max, tweenInfo)
    local min = min or 1
    local max = max or 100
    local tweenInfo = tweenInfo or {0}

    if typeof(tweenInfo) == "number" then
        tweenInfo = {tweenInfo}
    end

    local sliderTypes = {
        Updated = Signal.new()
    }

    sliderTypes = utility.format_table(sliderTypes)

    local function slide(input)
        local sizeX = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
        local posX = math.clamp(sizeX * slider.AbsoluteSize.X, 0, slider.AbsoluteSize.X - ball.AbsoluteSize.X)
        framework:Tween(ball, tweenInfo, {Position = UDim2.new(0, posX, 0, 0)})

        local value = math.floor((((max - min) * sizeX) + min))

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

return framework
