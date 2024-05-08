CreateThread(function()
    if X.Settings.textui == 'esx' or X.Settings.notify.script == 'esx' then
        ESX = exports['es_extended']:getSharedObject()
    end
end)
lib.locale()

if X.Settings.useTarget then
    CreateThread(function()
        local washingmachines = lib.callback.await('X-MoneyWash:server:GetMachines', false)
        for k, v in pairs(washingmachines) do
            exports.ox_target:addSphereZone({
                coords = vec3(v.x, v.y, v.z),
                radius = X.Settings.distance,
                options = {
                    {
                        name = 'moneywash',
                        event = 'X-MoneyWash:Target',
                        icon = 'fa-solid fa-dollar-sign',
                        label = locale('moneywash'),
                    }
                }
            })
        end
    end)

    RegisterNetEvent("X-MoneyWash:Target")
    AddEventHandler("X-MoneyWash:Target", function()
        MoneywashMenu()
    end)
else
    CreateThread(function()
        local washingmachines = lib.callback.await('X-MoneyWash:server:GetMachines', false)
        for k, v in pairs(washingmachines) do
            local point = lib.points.new({
                coords = v,
                distance = X.Settings.distance,
            })

            function point:onExit()
                if X.Settings.textui == 'ox_lib' then
                    lib.hideTextUI()
                end
            end

            function point:nearby()
                if X.Settings.marker.enable then
                    if self.currentDistance < self.distance then
                        DrawMarker(X.Settings.marker.type, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, X.Settings.marker.size.x, X.Settings.marker.size.y, X.Settings.marker.size.z, 200, 20, 20, 50, false, true, 2, false, nil, nil, false)
                    end
                end

                if X.Settings.textui == 'ox_lib' then
                    lib.showTextUI('[E] - ' .. locale('moneywash'))
                elseif X.Settings.textui == 'esx' then
                    ESX.ShowHelpNotification('~INPUT_PICKUP~ - ' .. locale('moneywash'))
                end

                if self.currentDistance < 1 and IsControlJustReleased(0, 38) then
                    MoneywashMenu()
                end
            end
        end
    end)
end

MoneywashMenu = function()
    local input = lib.inputDialog(locale('moneywash'), {
        {type = 'number', label = locale('value'), description = locale('howmuch'), icon = X.Settings.currency, min = X.Settings.washing.mincount, max = X.Settings.washing.maxcount},
    })

    if input then
        local count = lib.callback.await('X-MoneyWash:server:getDirtyMoney', false)
        
        if count == 0 then
            Notify(locale('error'), locale('notenought'), 'error')
        elseif count <= input[1] then
            Notify(locale('error'), locale('notenought'), 'error')
        else
            local alert = lib.alertDialog({
                header = locale('areyousure'),
                content = locale('alert'):format(input[1]),
                centered = true,
                cancel = true,
                labels = {
                    cancel = locale('cancel'),
                    confirm = locale('confirm')
                }
            })

            if alert == 'confirm' then
                WashMoney(input[1])
            end
        end
    end
end

WashMoney = function(count)
    lib.callback.await('X-MoneyWash:server:removeDirtyMoney', false, count)
    Progress(X.Settings.washing.time, count)
end

Progress = function(time, count)
    local playerPed = PlayerPedId()
    local animDict = "missheist_agency3aig_23"
    local anim = "urinal_sink_loop"
    local washingFee = X.Settings.washing.fee -- Lisätty uusi muuttuja pesulan maksulle

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(0)
    end

    TaskPlayAnim(playerPed, animDict, anim, 8.0, -8.0, -1, 1, 0, false, false, false)

    if X.Settings.progress.type == 'circle' then
        if lib.progressCircle({
            duration = time * 1000,
            label = locale('washing'),
            position = X.Settings.progress.position,
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
            },
        }) then
            local cleanMoney = count - (count * washingFee) -- Lasketaan puhdas rahamäärä vähentämällä pesulan maksu
            lib.callback.await('X-MoneyWash:server:giveMoney', false, cleanMoney, X.Settings.money.cash)
        else
            lib.callback.await('X-MoneyWash:server:giveMoney', false, count, X.Settings.money.dirty)
        end
    else
        if lib.progressBar({
            duration = time * 1000,
            label = locale('washing'),
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
            },
        }) then
            local cleanMoney = count - (count * washingFee) -- Lasketaan puhdas rahamäärä vähentämällä pesulan maksu
            lib.callback.await('X-MoneyWash:server:giveMoney', false, cleanMoney, X.Settings.money.cash)
        else
            lib.callback.await('X-MoneyWash:server:giveMoney', false, count, X.Settings.money.dirty)
        end
    end

    ClearPedTasks(playerPed)
end
