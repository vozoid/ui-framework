local framework = loadstring(readfile("ui-framework/modules/framework.lua"))()

framework.dropdowns = {}
framework.dropdowns.current = nil

function Dropdown(object, content, template)
    local dropdownTypes = {
        Updated = framework.signal.new(),
        NoneChosen = framework.signal.new(),
        Refreshed = framework.signal.new(),
        Removed = framework.signal.new(),
        Added = framework.signal.new()
    }

    local instances = {}

    dropdownTypes = framework.format_table(dropdownTypes)

    for _, option in next, content do
        local obj = template:Clone()
        obj.Parent = object
        
        if obj.ClassName:find("Text") then
            obj.Text = option
        end

        instances[option] = obj
        table.insert(framework.dropdowns, obj)

        obj.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if framework.dropdowns.current ~= option then
                    framework.dropdowns.current = option
                    dropdownTypes.Updated:Fire(option, obj)
                else
                    dropdownTypes.Updated:Fire(nil, nil)
                    dropdownTypes.NoneChosen:Fire()
                end
            end
        end)
    end

    function dropdownTypes:Set(option)
        if instances[option] then
            if framework.dropdowns.current ~= option then
                framework.dropdowns.current = option
                dropdownTypes.Updated:Fire(option, instances[option])
            end
        end
    end

    function dropdownTypes:Remove(option)
        if instances[option] then
            instances[option]:Destroy()
            dropdownTypes.Removed:Fire(option, instances[option])
            table.remove(instances, table.find(instances, option))

            if framework.dropdowns.current == option then
                dropdownTypes.Updated:Fire(nil, nil)
                dropdownTypes.NoneChosen:Fire()
            end
        end
    end

    function dropdownTypes:Add(option)
        local obj = template:Clone()
        obj.Parent = object
        
        if obj.ClassName:find("Text") then
            obj.Text = option
        end

        dropdownTypes.Added:Fire(option, obj)

        instances[option] = obj
        table.insert(framework.dropdowns, obj)

        obj.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if framework.dropdowns.current ~= option then
                    framework.dropdowns.current = option
                    dropdownTypes.Updated:Fire(option, obj)
                else
                    dropdownTypes.Updated:Fire(nil, nil)
                    dropdownTypes.NoneChosen:Fire()
                end
            end
        end)
    end

    return dropdownTypes
end

return Dropdown
