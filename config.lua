X = {}

-- Edit locations --> server/sv_locations.lua

X.Settings = {
    distance = 2, -- How long distance?
    textui = 'ox_lib', -- 'ox_lib' or 'esx' 
    currency = 'euro', -- 'euro' or 'dollar'
    notify = {
        script = 'ox_lib', -- 'ox_lib' or 'esx' or 'bulletin' or 'mythic_notify' or 'okokNotify' or 'custom'
        position = 'bottom', -- Only if script = 'ox_lib' or 'bulletin'
        time = 5 -- Seconds
    },
    money = {
        cash = 'money', -- Your cash item name
        dirty = 'black_money' -- Your dirty money item name
    },
    progress = { -- Only ox_lib
        type = 'circle', -- 'bar' or 'circle'
        position = 'bottom', -- only if type = 'circle'
    },
    marker = {
        enable = true, -- Enable marker,
        type = 2,
        size = {
            x = 0.3,
            y = 0.3,
            z = 0.3
        }
    },
    washing = {
        mincount = 1000, -- Min count
        maxcount = 10000, -- Max count
        time = 10 -- Seconds
    },
}