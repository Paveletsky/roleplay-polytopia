polyinv = polyinv or {}

print '[~] LIB - Inventory Init.'

if SERVER then
    AddCSLuaFile "polyinv/client.lua"
    include "polyinv/server.lua"
    include "config/polyitems.lua"
else
    include "polyinv/client.lua"
end
