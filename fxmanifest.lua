fx_version 'cerulean'
game 'gta5'
lua54 'yes'

version '1.0.0'

client_scripts {
    'client/cl_*.lua'
}

server_scripts {
    'server/sv_*.lua',
    '@oxmysql/lib/MySQL.lua'
}

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua'
}

files {
    'locales/*.json'
}

escrow_ignore {
    'config.lua',
    'client/cl_custom.lua',
    'locales/*.json'
}