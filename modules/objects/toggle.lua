local framework = loadstring(readfile("ui-framework/modules/framework.lua"))()

function Toggle(object)
    local toggled = false

    local toggleTypes = {
        Toggled = framework.signal.new(), 
        Enabled = framework.signal.new(), 
        Disabled = framework.signal.new()
    }

    toggleTypes = framework.format_table(toggleTypes)

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

return Toggle
