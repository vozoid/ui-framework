local toggle = framework.toggle(frame)

toggle.toggled:connect(function(value)
    print(value)
end)

toggle.enabled:connect(function()
    print("enabled")
end)

toggle.disabled:connect(function()
    print("disabled")
end)

toggle:toggle()
