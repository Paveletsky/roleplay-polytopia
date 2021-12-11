local PL = FindMetaTable( 'Player' )

local function uuid_generate()
    local result = ""
    for i=0,5 do
        local substr = ""
        for j=0,4 do
            local let
            if(math.random(0, 1) == 1) then let = string.char(math.random(97, 122)) else let = math.random(0, 9) end
            substr = substr .. let
        end
        result = result .. substr
        if (i != 5) then result = result .. "-" end
    end
    
    return result
end

function polyinv.notesOpen()
    netstream.Start( ply, 'polyinv.noteOpen', polyinv.List )
end

function polyinv.infoPage( id )
    local itemCl = polyinv.List[id]
    netstream.Start( ply, 'polyinv.info', itemCl )
end

function PL:openCustomItemsMenu()
    netstream.Start( self, 'polyinv.openCustoms', polyinv.List, self:CurrentCharInventory() )
end

netstream.Hook( 'polyinv.give', function( ply, id )
    if !ply:IsSuperAdmin() then ply:ChatPrint( 'Что, решил побаловаться?' ) return end
    ply:GiveItem( id ) 
end)

netstream.Hook( 'polyinv.createItem', function( ply, name, desc, logo, max, weight )
    if !ply:IsSuperAdmin() then ply:ChatPrint( 'Еще чё?' ) return end

    local i = 0
    for _, _ in pairs( polyinv.List ) do 
        i = i + 1
    end
    polyinv.registerCustomItem({
        name = name or 'Без имени',
        class = 'lol',
        desc = desc or 'Без описания',
        logo = logo or 'poly/prize.png',
        max = max or 1,
        weight = weight or 0.3,
        canUse = false,
        isCustom = true,
    })
    ply:GiveItem( 'lol' )
end)
-- Entity(1):GiveItem( 'lol' )

netstream.Hook( 'polyinv.sv-infoOpen', function( ply, id ) 
    polyinv.infoPage( id )
end)

netstream.Hook( 'polyinv.sv-noteOpen', polyinv.notesOpen )

netstream.Hook( 'polyinv.sv-customOpen', function( ply ) 
    ply:openCustomItemsMenu()
end)

-- game.ConsoleCommand("hostname Политопия - Тяжелые времена \n")
-- RunConsoleCommand( 'hostname', '<P> Политопия. Тяжелые времена' )