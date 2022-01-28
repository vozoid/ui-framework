local framework = loadstring(readfile("ui-framework/modules/framework.lua"))()

function Button(object)
    local buttonTypes = {
        Clicked = framework.signal.new()
    }

    buttonTypes = framework.format_table(buttonTypes)

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

return Button
