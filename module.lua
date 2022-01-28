if not isfolder("ui-framework") then
    makefolder("ui-framework")
end

if not isfile("ui-framework/version.txt") then
    writefile("ui-framework/version.txt", "")
end

if readfile("ui-framework/version.txt") ~= game:HttpGet("https://raw.githubusercontent.com/vozoid/ui-framework/main/version.txt") then
    makefolder("ui-framework/modules")
    -- modules
    writefile("ui-framework/modules/signal.lua", game:HttpGet("https://raw.githubusercontent.com/vozoid/signal-library/main/main.lua"))
    writefile("ui-framework/modules/framework.lua", game:HttpGet("https://raw.githubusercontent.com/vozoid/ui-framework/main/modules/framework.lua"))

    makefolder("ui-framework/modules/objects")
    -- objects
    writefile("ui-framework/modules/objects/button.lua", game:HttpGet("https://raw.githubusercontent.com/vozoid/ui-framework/main/modules/objects/button.lua"))
    writefile("ui-framework/modules/objects/toggle.lua", game:HttpGet("https://raw.githubusercontent.com/vozoid/ui-framework/main/modules/objects/toggle.lua"))
    writefile("ui-framework/modules/objects/box.lua", game:HttpGet("https://raw.githubusercontent.com/vozoid/ui-framework/main/modules/objects/box.lua"))

    writefile("ui-framework/version.txt", game:HttpGet("https://raw.githubusercontent.com/vozoid/ui-framework/main/version.txt"))
end

local framework = loadstring(readfile("ui-framework/modules/framework.lua"))()
framework.button = framework.import("button")
framework.toggle = framework.import("toggle")
framework.box = framework.import("box")

return framework
