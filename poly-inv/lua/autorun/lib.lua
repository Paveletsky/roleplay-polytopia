polyinv = polyinv or {}

print '[~] LIB - Inventory Init.'

include "inv/shared.lua"

if SERVER then
    AddCSLuaFile "inv/client.lua"
    AddCSLuaFile "inv/shared.lua"
    include "inv/server.lua"
else
    include "inv/client.lua"
end
