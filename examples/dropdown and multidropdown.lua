local gui = Instance.new("ScreenGui", game.CoreGui)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 200)
frame.Position = UDim2.new(0, 50, 0, 50)

local list = Instance.new("UIListLayout", frame)

local template = Instance.new("TextButton")
template.Size = UDim2.new(1, 0, 0, 20)

local dropdown = framework.dropdown(frame, {"Option 1", "Option 2"}, template)
-- local dropdown = framework.multidropdown(frame, {"Option 1", "Option 2"}, template)

dropdown.Updated:connect(function(option, obj)
    print(option, obj)
end)

dropdown.NoneSelected:connect(function()
    print("NONE")
end)

dropdown.Selected:connect(function(option, obj)
    obj.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
end)

dropdown.Deselected:connect(function(option, obj)
    obj.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
end)

dropdown.Removed:connect(function(opt, obj)
    print(opt)
end)

drop:Remove("Option 1")

dropdown.Added:connect(function(option)
    print(option)
end)

drop:Add("Option 3")
drop:Set("Option 2")

dropdown.Refreshed:connect(function(tbl)
    table.foreach(tbl, print)
end)

drop:Refresh({"Option 4",'Option 5'})

drop:Set()
