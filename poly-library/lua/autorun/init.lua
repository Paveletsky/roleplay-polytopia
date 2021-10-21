library = library or {}

sql.Query("CREATE TABLE IF NOT EXISTS testpolysql('id' INTEGER NOT NULL, 'bruh' TEXT NOT NULL, 'bruhovich' TEXT NOT NULL, PRIMARY KEY('id'));")

library.SQL = {}

library.SQL.MySQL = true
library.SQL.Host = "188.40.204.221"
library.SQL.Username = "lasexille"
library.SQL.Password = "yG0cK8eY5njS"
library.SQL.Database_name = "s1_testpolysql"
library.SQL.Database_port = 3306
library.SQL.Preferred_module = "mysqloo"

function library.SQL.Query( data )

	return sql.Query( data )

end

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

library.shared('library/lib_init')

