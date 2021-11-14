library = library or {}

--
-- подключение библиотеки
--

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

library.shared('library/modules')


if SERVER then

	resource.AddWorkshop( '1363659220' ) -- survivor citizens
	resource.AddWorkshop( '2097587957' ) -- post apoc. models
	resource.AddWorkshop( '2078732967' ) -- alyx models
	resource.AddWorkshop( '2563285523' ) -- ench. civilies
	resource.AddWorkshop( '2136700990' ) -- army models

	resource.AddWorkshop( '822313622' ) -- rp isolation

	resource.AddWorkshop('2651123345') -- [~] Polytopia Assets - Icons

end