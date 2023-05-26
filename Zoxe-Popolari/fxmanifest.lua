fx_version 'adamant'
game 'gta5'
lua54 'yes'

name 'Case Popolari'
author '! ^Zoxe$#5386'
version "1.0.0"
repository "https://github.com/anosmus/Zoxe-Popolari"
description 'Zoxe-Popolari'
discord 'https://discord.gg/avJYpPCfuG'

shared_script "@es_extended/imports.lua"
shared_script '@ox_lib/init.lua'

shared_script {
    'shared/**.lua'
}

client_scripts {
    'client/**.lua'
}

server_scripts {
    'server/**.lua'
}

