polyinv = polyinv or {}
polyinv.Core = polyinv.Core or {}

print '[~] LIB - Inventory Init.'

if SERVER then
    AddCSLuaFile "polyinv/client.lua"
    AddCSLuaFile "head/client.lua"

    include "polyinv/server.lua"
    include "head/server.lua"

    include "config/polyitems.lua"
else
    include "polyinv/client.lua"
    include "head/client.lua"

end
