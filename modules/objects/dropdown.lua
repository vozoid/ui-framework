local framework = loadstring(readfile("ui-framework/modules/framework.lua"))()

function Dropdown(object, content, template)
    local dropdownTypes = {
        Updated = framework.signal.new(),
        Chosen = framework.signal.new(),
        Unchosen = framework.signal.new(),
        NoneChosen = framework.signal.new(),
        Refreshed = framework.signal.new(),
        Removed = framework.signal.new(),
        Added = framework.signal.new()
    }

    local instances = {}
    local current = nil

    dropdownTypes = framework.format_table(dropdownTypes)

    for _, option in next, content do
        local obj = template:Clone()
        obj.Parent = object
        
        if obj.ClassName:find("Text") then
            obj.Text = option
        end

        instances[option] = obj

        obj.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if current ~= option then
                    current = option
                    dropdownTypes.Chosen:Fire(option, instances[option])
                    dropdownTypes.Updated:Fire(option, instances[option])
                else
                    current = nil
                    dropdownTypes.Updated:Fire(nil, nil)
                    dropdownTypes.Unchosen:Fire(option, instances[option])
                    dropdownTypes.NoneChosen:Fire()
                end
            end
        end)
    end

    function dropdownTypes:Set(option)
        if option == nil then
            current = nil
            dropdownTypes.Updated:Fire(nil, nil)
            dropdownTypes.NoneChosen:Fire()
        end

        if instances[option] then
            if current ~= option then
                current = option
                dropdownTypes.Chosen:Fire(option, instances[option])
                dropdownTypes.Updated:Fire(option, instances[option])
            end
        end
    end

    function dropdownTypes:Refresh(tbl)
        content = tbl

        current = nil
        dropdownTypes.Updated:Fire(nil, nil)
        dropdownTypes.NoneChosen:Fire()

        dropdownTypes.Refreshed:Fire(tbl)

        for i, obj in next, instances do
            obj:Destroy()
            table.remove(instances, table.find(instances, i))
        end

        for _, option in next, content do
            local obj = template:Clone()
            obj.Parent = object
            
            if obj.ClassName:find("Text") then
                obj.Text = option
            end
    
            instances[option] = obj
    
            obj.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if current ~= option then
                        current = option
                        dropdownTypes.Chosen:Fire(option, instances[option])
                        dropdownTypes.Updated:Fire(option, instances[option])
                    else
                        current = nil
                        dropdownTypes.Updated:Fire(nil, nil)
                        dropdownTypes.Unchosen:Fire(option, instances[option])
                        dropdownTypes.NoneChosen:Fire()
                    end
                end
            end)
        end
    end

    function dropdownTypes:Remove(option)
        if instances[option] then
            instances[option]:Destroy()
            dropdownTypes.Removed:Fire(option, instances[option])
            table.remove(instances, table.find(instances, option))

            if current == option then
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

        obj.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if current ~= option then
                    current = option
                    dropdownTypes.Chosen:Fire(option, instances[option])
                    dropdownTypes.Updated:Fire(option, instances[option])
                else
                    current = nil
                    dropdownTypes.Updated:Fire(nil, nil)
                    dropdownTypes.Unchosen:Fire(option, instances[option])
                    dropdownTypes.NoneChosen:Fire()
                end
            end
        end)
    end

    return dropdownTypes
end

return Dropdown
