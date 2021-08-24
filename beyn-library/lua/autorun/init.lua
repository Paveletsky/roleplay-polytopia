library = library or {}

function library.server(path)

	path = path .. '.lua'
	if SERVER then include(path) end

end

function library.client(path)

	path = path .. '.lua'
	if SERVER then AddCSLuaFile(path) end
	if CLIENT then include(path) end

end

function library.shared(path)

	path = path .. '.lua'
	if SERVER then AddCSLuaFile(path) end
	include(path)

end

function library.module(path)

	if file.Exists(path .. '/shared.lua', 'LUA') then library.shared(path .. '/shared') end
	if file.Exists(path .. '/server.lua', 'LUA') then library.server(path .. '/server') end
	if file.Exists(path .. '/client.lua', 'LUA') then library.client(path .. '/client') end

end

library.shared('library/lib_init')
