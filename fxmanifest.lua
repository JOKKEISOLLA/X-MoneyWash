fx_version 'cerulean'
game 'gta5'
lua54 'yes'
version: '1.0.0'

client_scripts {
    'client/cl_*.lua'
}

server_scripts {
    'server/sv_*.lua'
}

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua'
}

files {
    'locales/*.json'
}
