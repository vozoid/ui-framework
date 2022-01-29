local framework = loadstring(readfile("ui-framework/modules/framework.lua"))()
local inputService = game:GetService("UserInputService")

function Keybind(object, blacklist)
    local keybindTypes = {
        Updated = framework.signal.new(),
        Pressed = framework.signal.new()
    }

    keybindTypes = framework.format_table(keybindTypes)
    
    blacklist = blacklist or {}

    local keyChosen

    local function bind()
        local binding
        binding = inputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if not table.find(blacklist, input.KeyCode) then
                    task.wait()
                    keyChosen = input.KeyCode
                    keybindTypes.Updated:Fire(keyChosen)
                    binding:Disconnect()
                end
            else
                if not table.find(blacklist, input.UserInputType) then
                    task.wait()
                    keyChosen = input.UserInputType
                    keybindTypes.Updated:Fire(keyChosen)
                    binding:Disconnect()
                end
            end
        end)
    end

    object.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            task.wait()
            bind()
        end
    end)

    inputService.InputBegan:Connect(function(input)
        if not inBind then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == keyChosen then
                    keybindTypes.Pressed:Fire()
                end
            end

            if input.UserInputType == keyChosen then
                keybindTypes.Pressed:Fire()
            end
        end
    end)

    function keybindTypes:Set(key)
        if not table.find(blacklist, key) then
            keyChosen = key
            keybindTypes.Updated:Fire(keyChosen)
        end
    end

    return keybindTypes
end

return Keybind
