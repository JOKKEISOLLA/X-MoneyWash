Notify = function(title, msg, type)
    if X.Settings.notify.script == 'ox_lib' then
        lib.notify({
            title = title,
            description = msg,
            type = type,
            position = X.Settings.notify.position,
            duration = X.Settings.notify.time * 1000
        })
    elseif X.Settings.notify.script == 'esx' then
        TriggerClientEvent('esx:showNotification', cache.ped, msg, type, X.Setting.notify.time * 1000)
    elseif X.Settings.notify.script == 'bulletin' then
        exports.bulletin:Send({
            message = msg,
            timeout = X.Settings.notify.time * 1000,
            theme = type,
            position = X.Settings.notify.position
        })
    elseif X.Settings.notify.script == 'mythic_notify' then
        exports['mythic_notify']:DoHudText(type, msg)
    elseif X.Settings.notify.script == 'okokNotify' then
        exports['okokNotify']:Alert(title, msg, X.Settings.notify.time * 1000, type, false)
    elseif X.Settings.notify.script == 'custom' then
        -- Add your code here
    end
end