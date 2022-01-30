local inputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local coreGui = game:GetService("CoreGui")

local framework = {signal = loadstring(game:HttpGet("https://raw.githubusercontent.com/vozoid/signal-library/main/main.lua"))()}

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

function framework.Button(object)
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

function framework.Toggle(object)
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

function framework.Box(object)
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

function framework.SizeSlider(slider, fill, min, max, tweenInfo)
    local min = min or 1
    local max = max or 100
    local tweenInfo = tweenInfo or {0}

    if typeof(tweenInfo) == "number" then
        tweenInfo = {tweenInfo}
    end

    local sliderTypes = {
        Updated = framework.signal.new()
    }

    sliderTypes = framework.format_table(sliderTypes)

    local function slide(input)
        local sizeX = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
        framework.tween(fill, tweenInfo, {Size = UDim2.new(sizeX, 0, 1, 0)})

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

        fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)

        sliderTypes.Updated:Fire(value)
    end

    return sliderTypes
end

function framework.PositionSlider(slider, ball, min, max, tweenInfo)
    local min = min or 1
    local max = max or 100
    local tweenInfo = tweenInfo or {0}

    if typeof(tweenInfo) == "number" then
        tweenInfo = {tweenInfo}
    end

    local sliderTypes = {
        Updated = framework.signal.new()
    }

    sliderTypes = framework.format_table(sliderTypes)

    local function slide(input)
        local sizeX = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
        local posX = math.clamp(sizeX * slider.AbsoluteSize.X, 0, slider.AbsoluteSize.X - ball.AbsoluteSize.X)
        local valX = posX / (slider.AbsoluteSize.X - ball.AbsoluteSize.X)
        
        framework.tween(ball, tweenInfo, {Position = UDim2.new(0, posX, 0, 0)})

        local value = math.floor((((max - min) * valX) + min))

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

function framework.Dropdown(object, content, template)
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
    local current = nil

    dropdownTypes = framework.format_table(dropdownTypes)

    for _, option in next, content do
        local obj = template:Clone()
        obj.Parent = object
        
        if obj:FindFirstChild("Text") then
            obj.Text.Text = option
        elseif obj.ClassName:find("Text") then
            obj.Text = option
        end

        instances[option] = obj

        obj.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if current ~= option then
                    current = option
                    dropdownTypes.Selected:Fire(option, instances[option])
                    dropdownTypes.Updated:Fire(option, instances[option])
                else
                    current = nil
                    dropdownTypes.Updated:Fire(nil, nil)
                    dropdownTypes.Deselected:Fire(option, instances[option])
                    dropdownTypes.NoneSelected:Fire()
                end
            end
        end)
    end

    function dropdownTypes:Set(option)
        if option == nil then
            current = nil
            dropdownTypes.Updated:Fire(nil, nil)
            dropdownTypes.NoneSelected:Fire()
        end

        if instances[option] then
            if current ~= option then
                current = option
                dropdownTypes.Selected:Fire(option, instances[option])
                dropdownTypes.Updated:Fire(option, instances[option])
            end
        end
    end

    function dropdownTypes:Refresh(tbl)
        content = tbl

        current = nil
        dropdownTypes.Updated:Fire(nil, nil)
        dropdownTypes.NoneSelected:Fire()

        dropdownTypes.Refreshed:Fire(tbl)

        for i, obj in next, instances do
            obj:Destroy()
            table.remove(instances, table.find(instances, i))
        end

        for _, option in next, content do
            local obj = template:Clone()
            obj.Parent = object
            
        if obj:FindFirstChild("Text") then
            obj.Text.Text = option
        elseif obj.ClassName:find("Text") then
            obj.Text = option
        end
    
            instances[option] = obj
    
            obj.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if current ~= option then
                        current = option
                        dropdownTypes.Selected:Fire(option, instances[option])
                        dropdownTypes.Updated:Fire(option, instances[option])
                    else
                        current = nil
                        dropdownTypes.Updated:Fire(nil, nil)
                        dropdownTypes.Deselected:Fire(option, instances[option])
                        dropdownTypes.NoneSelected:Fire()
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
                dropdownTypes.NoneSelected:Fire()
            end
        end
    end

    function dropdownTypes:Add(option)
        local obj = template:Clone()
        obj.Parent = object
        
        if obj:FindFirstChild("Text") then
            obj.Text.Text = option
        elseif obj.ClassName:find("Text") then
            obj.Text = option
        end

        dropdownTypes.Added:Fire(option, obj)

        instances[option] = obj

        obj.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if current ~= option then
                    current = option
                    dropdownTypes.Selected:Fire(option, instances[option])
                    dropdownTypes.Updated:Fire(option, instances[option])
                else
                    current = nil
                    dropdownTypes.Updated:Fire(nil, nil)
                    dropdownTypes.Deselected:Fire(option, instances[option])
                    dropdownTypes.NoneSelected:Fire()
                end
            end
        end)
    end

    return dropdownTypes
end

function framework.MultiDropdown(object, content, template)
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
        
        if obj:FindFirstChild("Text") then
            obj.Text.Text = option
        elseif obj.ClassName:find("Text") then
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

function framework.Keybind(object, blacklist)
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

return framework
