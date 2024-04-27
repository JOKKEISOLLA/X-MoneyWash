WashingMachines = {
    vec4(-1210.7004, 374.8719, 79.9866, 282.5244),
}

lib.callback.register('X-MoneyWash:server:GetMachines', function(source)
    return WashingMachines
end)
