fx_version 'cerulean'
games { 'gta5' }
author 'Pitu7944#2711'
description 'Pitu7944\'s multiJob'
version '1.0.0'


server_scripts {
    '@es_extended/locale.lua',
	'locales/pl.lua',
    'Config.lua',
    'server/globals.lua',
    '@mysql-async/lib/MySQL.lua',
    'server/functions.lua',
    'server/database.lua',
    'server/server.lua',
    'server/callbacks.lua'
}

client_scripts {
    '@es_extended/locale.lua',
	'locales/pl.lua',
    'Config.lua',
    'client/functions.lua',
    'client/client.lua',
}


-- uncomment/comment to the addons that you have! --

server_scripts {
	'addons/locks/config.lua',
	'addons/locks/server.lua'
}

client_scripts {
	'addons/locks/config.lua',
	'addons/locks/client.lua'
}

server_scripts {
	'addons/handcuffs/config.lua',
	'addons/handcuffs/server.lua'
}

client_scripts {
	'addons/handcuffs/config.lua',
	'addons/handcuffs/client.lua'
}

dependency 'es_extended'
--[[
    ░░░░░░░░░░░░░▄▄▀▀▀▀▀▀▄▄
    ░░░░░░░░░░▄▄▀▄▄▄█████▄▄▀▄
    ░░░░░░░░▄█▀▒▀▀▀█████████▄█▄
    ░░░░░░▄██▒▒▒▒▒▒▒▒▀▒▀▒▀▄▒▀▒▀▄
    ░░░░▄██▀▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▄
    ░░░░██▀▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▌
    ░░░▐██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▐█
    ░▄▄███▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█
    ▐▒▄▀██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▐▌
    ▌▒▒▌▒▀▒▒▒▒▒▒▄▀▀▄▄▒▒▒▒▒▒▒▒▒▒▒▒█▌
    ▐▒▀▒▌▒▒▒▒▒▒▒▄▄▄▄▒▒▒▒▒▒▒▀▀▀▀▄▒▐
    ░█▒▒▌▒▒▒▒▒▒▒▒▀▀▒▀▒▒▐▒▄▀██▀▒▒▒▌
    ░░█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▐▒▒▒▒▒▒▒▒█
    ░░░▀▌▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▌▒▒▒▒▒▒▄▀
    ░░░▐▒▒▒▒▒▒▒▒▒▄▀▐▒▒▒▒▒▐▒▒▒▒▄▀
    ░░▄▌▒▒▒▒▒▒▒▄▀▒▒▒▀▄▄▒▒▒▌▒▒▒▐▀▀▀▄▄▄
    ▄▀░▀▄▒▒▒▒▒▒▒▒▀▀▄▄▄▒▄▄▀▌▒▒▒▌░░░░░░
    ▐▌░░░▀▄▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▄▀░░░░░░░
    ░█░░░░░▀▄▄▒▒▒▒▒▒▒▒▒▒▒▒▄▀░█░░░░░░░
    ░░█░░░░░░░▀▄▄▄▒▒▒▒▒▒▄▀░░░░█░░░░░░
    ░░░█░░░░░░░░░▌▀▀▀▀▀▀▐░░░░░▐▌░░░░░
    b͋y͋ ͋P͋i͋t͋u͋7͋9͋4͋4͋  jakies problemy?
    pisz do Pitu7944#2711 na discordzie!
]]--