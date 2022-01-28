local inputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local coreGui = game:GetService("CoreGui")

local framework = {signal = loadstring(readfile("ui-framework/modules/signal.lua"))()}

function framework.format_table(tbl)
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

framework = framework.format_table(framework)

framework.forcedProperties = {}

function framework.import(file)
    return loadstring(readfile(("ui-framework/modules/objects/%s.lua"):format(file)))()
end

function framework.create(object)
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

function framework.tween(obj, info, properties, callback)
    local anim = tweenService:Create(obj, TweenInfo.new(unpack(info)), properties)
    anim:Play()

    if callback then
        anim.Completed:Connect(callback)
    end
end

function framework.dragify(object, speed)
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
            framework.tween(object, {speed}, {Position = UDim2.new(objectPosition.X.Scale, objectPosition.X.Offset + (input.Position - start).X, objectPosition.Y.Scale, objectPosition.Y.Offset + (input.Position - start).Y)})
        end
    end)
end

return framework
