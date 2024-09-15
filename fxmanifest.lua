fx_version "adamant"
game "gta5"

author 'berxt.ogg & torpak.'
description 'Pause Menu by Nexus Dev. | discord.gg/nexusdev | https://nexusdev.online'
version '1.0.0'

ui_page "ui/index.html"
files {
    "ui/**/**",
}

shared_scripts {
	'config.lua'
}

client_scripts {
	"client.lua"
}

server_scripts {
	"server.lua"
}

