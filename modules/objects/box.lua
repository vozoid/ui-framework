local framework = loadstring(game:HttpGet("https://raw.githubusercontent.com/vozoid/ui-framework/main/modules/framework.lua"))()

function Box(object)
    local boxTypes = {
        Updated = framework.signal.new()
    }

    boxTypes = framework.format_table(boxTypes)

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

return Box
