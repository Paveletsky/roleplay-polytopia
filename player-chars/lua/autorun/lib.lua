polychars = polychars or {}

print '[~] LIB - Character System loaded.'

include "chars/shared.lua"

if SERVER then
    AddCSLuaFile "chars/client.lua"
    AddCSLuaFile "chars/shared.lua"
    include "modules/mysqlite.lua"
    include "chars/server.lua"
else
    include "chars/client.lua"
end
