CreateThread(function()
    if X.Settings.textui == 'esx' or X.Settings.notify.script == 'esx' then
        ESX = exports['es_extended']:getSharedObject()
    end
end)
lib.locale()

CreateThread(function()
    local washingmachines = lib.callback.await('X-MoneyWash:server:GetMachines', false)
    for k,v in pairs(washingmachines) do
        local point = lib.points.new({
            coords = v,
            distance = X.Settings.distance,
        })


        if X.Settings.prop == "ped" then
            lib.requestModel(X.Settings.ped)
            local ped = CreatePed(false, GetHashKey(X.Settings.ped), v.x, v.y, v.z - 1, v.w, false, true)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true) 
        elseif X.Settings.prop == "object" then
            lib.requestModel(X.Settings.object)
            local object = CreateObject(GetHashKey(X.Settings.object), v.x, v.y, v.z, false,  false,  false)
            PlaceObjectOnGroundProperly(object)
		    SetEntityHeading(object, v.w)
			FreezeEntityPosition(object, true)
        end
         
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
                lib.showTextUI('[E] - ' ..locale('moneywash'))
            elseif X.Settings.textui == 'esx' then
                ESX.ShowHelpNotification('~INPUT_PICKUP~ - ' ..locale('moneywash'))
            end
         
            if self.currentDistance < 1 and IsControlJustReleased(0, 38) then
                MoneywashMenu()
            end
        end
    end
end)

MoneywashMenu = function()
    local input = lib.inputDialog(locale('moneywash'), {
        {type = 'number', label = locale('value'), description = locale('howmuch'), icon = X.Settings.currency, min = X.Settings.washing.mincount},
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
    FreezeEntityPosition(cache.ped, true)
    ClearPedTasksImmediately(cache.ped)
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
        }) then FreezeEntityPosition(cache.ped, false) lib.callback.await('X-MoneyWash:server:giveMoney', false, count, X.Settings.money.cash) else DisableControlAction(1,25,false) FreezeEntityPosition(cache.ped, false) lib.callback.await('X-MoneyWash:server:giveMoney', false, count, X.Settings.money.dirty) end
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
        }) then FreezeEntityPosition(cache.ped, false) lib.callback.await('X-MoneyWash:server:giveMoney', false, count, X.Settings.money.cash) else DisableControlAction(1,25,false) FreezeEntityPosition(cache.ped, false) lib.callback.await('X-MoneyWash:server:giveMoney', false, count, X.Settings.money.dirty) end
    end
end
