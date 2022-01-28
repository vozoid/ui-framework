local framework = loadstring(readfile("ui-framework/modules/framework.lua"))()
framework.button = framework.import("button")
framework.toggle = framework.import("toggle")
framework.box = framework.import("box")


return framework
