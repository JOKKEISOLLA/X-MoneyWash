lib.locale()

lib.callback.register('X-MoneyWash:server:getDirtyMoney', function(source)
    return exports.ox_inventory:GetItem(source, X.Settings.money.dirty, nil, true)
end)

lib.callback.register('X-MoneyWash:server:removeDirtyMoney', function(source, count)
    exports.ox_inventory:RemoveItem(source, X.Settings.money.dirty, count)
end)

lib.callback.register('X-MoneyWash:server:giveMoney', function(source, count, moneytype)
    exports.ox_inventory:AddItem(source, moneytype, count)
    print(moneytype)
    SendLogs(source, locale('newactivity'), locale('someonewashed'):format(count))
end)

lib.callback.register('X-MoneyWash:server:sendLogs', function(source, title, message)
    SendLogs(source, title, message)
end)