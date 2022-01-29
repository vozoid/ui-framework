local framework = loadstring(readfile("ui-framework/modules/framework.lua"))()

function MultiDropdown(object, content, template)
    local dropdownTypes = {
        Updated = framework.signal.new(),
        Selected = framework.signal.new(),
        Deselected = framework.signal.new(),
        NoneSelected = framework.signal.new(),
        Refreshed = framework.signal.new(),
        Removed = framework.signal.new(),
        Added = framework.signal.new()
    }

    local instances = {}
    local chosen = {}
    local chosenInstances = {}

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
                if not table.find(chosen, option) then
                    table.insert(chosen, option)
                    table.insert(chosenInstances, instances[option])
                    dropdownTypes.Selected:Fire(option, instances[option])
                    dropdownTypes.Updated:Fire(chosen, chosenInstances)
                else
                    table.remove(chosen, table.find(chosen, option))
                    table.remove(chosenInstances, table.find(chosenInstances, instances[option]))
                    dropdownTypes.Deselected:Fire(option, instances[option])
                    dropdownTypes.Updated:Fire(chosen, chosenInstances)

                    if #chosen < 1 then
                        dropdownTypes.NoneSelected:Fire()
                    end
                end
            end
        end)
    end

    function dropdownTypes:Set(option)
        if option == nil then
            dropdownTypes.Updated:Fire(nil, nil)
            dropdownTypes.NoneSelected:Fire()
        end

        if typeof(option) == "table" then
            for _, opt in next, option do
                if not table.find(chosen, opt) then
                    table.insert(chosen, opt)
                    table.insert(chosenInstances, instances[option])
                    dropdownTypes.Selected:Fire(option, instances[option])
                    dropdownTypes.Updated:Fire(chosen, chosenInstances)
                end
            end
        elseif instances[option] then
            if not table.find(chosen, option) then
                table.insert(chosen, option)
                table.insert(chosenInstances, instances[option])
                dropdownTypes.Selected:Fire(option, instances[option])
                dropdownTypes.Updated:Fire(chosen, chosenInstances)
            end
        end
    end

    function dropdownTypes:Refresh(tbl)
        content = tbl

        chosen = {}
        chosenInstances = {}
        dropdownTypes.Updated:Fire({}, {})
        dropdownTypes.NoneSelected:Fire()

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
                    if not table.find(chosen, option) then
                        table.insert(chosen, option)
                        table.insert(chosenInstances, instances[option])
                        dropdownTypes.Selected:Fire(option, instances[option])
                        dropdownTypes.Updated:Fire(chosen, chosenInstances)
                    else
                        table.remove(chosen, table.find(chosen, option))
                        table.remove(chosenInstances, table.find(chosenInstances, instances[option]))
                        dropdownTypes.Deselected:Fire(option, instances[option])
                        dropdownTypes.Updated:Fire(chosen, chosenInstances)
    
                        if #chosen < 1 then
                            dropdownTypes.NoneSelected:Fire()
                        end
                    end
                end
            end)
        end
    end

    function dropdownTypes:Remove(option)
        if typeof(option) == "table" then
            for _, opt in next, option do
                instances[opt]:Destroy()
                dropdownTypes.Removed:Fire(opt, instances[opt])
                table.remove(instances, table.find(instances, opt))
                if table.find(chosen, opt) then
                    table.remove(chosen, table.find(chosen, opt))
                    table.remove(chosenInstances, table.find(chosenInstances, opt))
                    dropdownTypes.Deselected:Fire(option, instances[option])
                    dropdownTypes.Updated:Fire(chosen, chosenInstances)
                end
            end
        elseif instances[option] then
            instances[option]:Destroy()
            dropdownTypes.Removed:Fire(option, instances[option])
            table.remove(instances, table.find(instances, option))
            if table.find(chosen, option) then
                table.remove(chosen, table.find(chosen, option))
                table.insert(chosenInstances, table.find(chosenInstances, instances[option]))
                dropdownTypes.Deselected:Fire(option, instances[option])
                dropdownTypes.Updated:Fire(chosen, chosenInstances)
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
                if not table.find(chosen, option) then
                    table.insert(chosen, option)
                    table.insert(chosenInstances, instances[option])
                    dropdownTypes.Selected:Fire(option, instances[option])
                    dropdownTypes.Updated:Fire(chosen, chosenInstances)
                else
                    table.remove(chosen, table.find(chosen, option))
                    table.remove(chosenInstances, table.find(chosenInstances, instances[option]))
                    dropdownTypes.Deselected:Fire(option, instances[option])
                    dropdownTypes.Updated:Fire(chosen, chosenInstances)

                    if #chosen < 1 then
                        dropdownTypes.NoneSelected:Fire()
                    end
                end
            end
        end)
    end

    return dropdownTypes
end

return MultiDropdown
