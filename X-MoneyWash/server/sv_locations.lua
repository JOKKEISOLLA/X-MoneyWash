WashingMachines = {
    vec3(-1228.28, 308.56, 71.28)
}

lib.callback.register('X-MoneyWash:server:GetMachines', function(source)
    return WashingMachines
end)