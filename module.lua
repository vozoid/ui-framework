local objects = {"button", "toggle", "box", "sizeslider", "positionslider", "dropdown", "multidropdown"}

if not isfolder("ui-framework") then
    makefolder("ui-framework")
end

if not isfile("ui-framework/version.txt") then
    writefile("ui-framework/version.txt", "")
end

if readfile("ui-framework/version.txt") ~= game:HttpGet("https://raw.githubusercontent.com/vozoid/ui-framework/main/version.txt") then
    delfolder("ui-framework")
    makefolder("ui-framework")

    makefolder("ui-framework/modules")
    -- modules
    writefile("ui-framework/modules/signal.lua", game:HttpGet("https://raw.githubusercontent.com/vozoid/ui-framework/main/signal.lua"))
    writefile("ui-framework/modules/framework.lua", game:HttpGet("https://raw.githubusercontent.com/vozoid/ui-framework/main/modules/framework.lua"))

    makefolder("ui-framework/modules/objects")
    -- objects
    for _, object in next, objects do
        writefile(("ui-framework/modules/objects/%s.lua"):format(object), game:HttpGet(("https://raw.githubusercontent.com/vozoid/ui-framework/main/modules/objects/%s.lua"):format(object)))
    end

    writefile("ui-framework/version.txt", game:HttpGet("https://raw.githubusercontent.com/vozoid/ui-framework/main/version.txt"))
end

local framework = loadstring(readfile("ui-framework/modules/framework.lua"))()

for _, object in next, objects do
    framework[object] = framework.import(object)
end

return framework
