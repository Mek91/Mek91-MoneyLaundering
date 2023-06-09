fx_version 'cerulean'

game 'gta5'

author 'mek91'

description 'Mek91ML - (Money Laundering)'

version '1.0'

shared_script {
    'Languages/*.lua',
    'Configs/*.lua'
}

server_script {
    'Files/Server.lua'
}

client_scripts {
    'Files/Client.lua'
}

dependencies {
	'qb-core'
}

lua54 'yes'