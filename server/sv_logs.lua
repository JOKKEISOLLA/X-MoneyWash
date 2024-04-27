local webhook = 'your webhook' -- Your webhook

SendLogs = function(source, title, message)
    local steamId = 'Not found'
    local license = 'Not found'
    local discord = 'Not found'

    for k, v in pairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len('steam:')) == 'steam:' then
            steamId = v
        elseif string.sub(v, 1, string.len('license:')) == 'license:' then
            license = v
        elseif string.sub(v, 1, string.len('discord:')) == 'discord:' then
            discordId = string.sub(v, 9)
            discord = '<@' .. discordId .. '>'
        end
    end

    local embed = {
        {
            ["title"] = "**X-MoneyWash - " ..title.. "**",
            ["description"] = message.. ' \n \n Information: \n Steam: `' ..steamId.. '` \n License: `' ..license.. '` \n Discord: ' ..discord,
        }
    }

    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = 'X-MoneyWash', embeds = embed}), { ['Content-Type'] = 'application/json' })
end