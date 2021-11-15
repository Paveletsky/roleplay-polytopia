disabledDefaults = disabledDefaults or {}

DarkRP.disabledDefaults["modules"] = {
    ["afk"]              = true,
    ["chatsounds"]       = true,
    ["events"]           = true,
    ["fpp"]              = true,
    ["f1menu"]           = true,
    ["f4menu"]           = true,
    ["hitmenu"]          = true,
    ["hud"]              = true,
    ["hungermod"]        = false,
    ["playerscale"]      = true,
    ["sleep"]            = true,
    ["fadmin"]           = true,
    ["animations"]       = true,
    ["chatindicator"]    = false,
}


DarkRP.disabledDefaults["shipments"] = {
    ["AK47"]         = false,
    ["Desert eagle"] = false,
    ["Fiveseven"]    = false,
    ["Glock"]        = false,
    ["M4"]           = false,
    ["Mac 10"]       = false,
    ["MP5"]          = false,
    ["P228"]         = false,
    ["Pump shotgun"] = false,
    ["Sniper rifle"] = false,
}


DarkRP.disabledDefaults["entities"] = {
	["Drug lab"]	  = true,
	["Gun lab"]	   = true,
	["Money printer"] = true,
	["Microwave"]	 = true, --Hungermod only
}


DarkRP.disabledDefaults["vehicles"] = {

}


DarkRP.disabledDefaults["food"] = {
	["Banana"]		   = true,
	["Bunch of bananas"] = true,
	["Melon"]			= true,
	["Glass bottle"]	 = true,
	["Pop can"]		  = true,
	["Plastic bottle"]   = true,
	["Milk"]			 = true,
	["Bottle 1"]		 = true,
	["Bottle 2"]		 = true,
	["Bottle 3"]		 = true,
	["Orange"]		   = true,
}

--[[---------------------------------------------------------------------------
Door groups
---------------------------------------------------------------------------]]
DarkRP.disabledDefaults["doorgroups"] = {
	["Cops and Mayor only"] = true,
	["Gundealer only"]	  = true,
}


--[[---------------------------------------------------------------------------
Ammo packets
---------------------------------------------------------------------------]]
DarkRP.disabledDefaults["ammo"] = {
	["Pistol ammo"]  = true,
	["Rifle ammo"]   = true,
	["Shotgun ammo"] = true,
}

--[[---------------------------------------------------------------------------
Agendas
---------------------------------------------------------------------------]]
DarkRP.disabledDefaults["agendas"] = {
	["Gangster's agenda"] = true,
	["Police agenda"] = true,
}

--[[---------------------------------------------------------------------------
Chat groups (chat with /g)
Chat groups do not have names, so their index is used instead.
---------------------------------------------------------------------------]]
DarkRP.disabledDefaults["groupchat"] = {
	[1] = true, -- Police group chat (mayor, cp, chief and/or your custom CP teams)
	[2] = true, -- Group chat between gangsters and the mobboss
	[3] = true, -- Group chat between people of the same team
}

--[[---------------------------------------------------------------------------
Demote groups
When anyone is demote from any job in this group, they will be temporarily banned
from every job in the group
---------------------------------------------------------------------------]]
DarkRP.disabledDefaults["demotegroups"] = {
	["Cops"]		 = false,
	["Gangsters"]	 = false,
}