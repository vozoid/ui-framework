local inputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local coreGui = game:GetService("CoreGui")

local framework = {Signal = loadstring(game:HttpGet("https://raw.githubusercontent.com/vozoid/Signal-library/main/main.lua"))()}

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
