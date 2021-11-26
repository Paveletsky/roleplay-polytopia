local PL = FindMetaTable( 'Player' )

if ( !sql.TableExists( "polytopia_inventory" ) ) then
    sql.Query( 'CREATE TABLE IF NOT EXISTS polytopia_inventory( steamid TEXT NOT NULL PRIMARY KEY , inventory TEXT )' )    
end

function PL:getInventory_2()
    local encoded = sql.Query( "SELECT inventory FROM polytopia_inventory WHERE steamid = " .. sql.SQLStr( self:SteamID() ) .. ";")
    local data = pon.decode( encoded[1].inventory )    
    return data
end

function PL:getInventory(  )
    local val = sql.Query("SELECT chars FROM polytopia_inventory WHERE steamid = " .. SQLStr( self:SteamID() ) )
    return val
end

function PL:openInventory( owner )
    if not owner then self:polychatNotify( 1, 'SteamID не найден.' ) return end
    local steam = player.GetBySteamID( owner )
    local charInfo = sql.Query( "SELECT * FROM polytopia_characters WHERE steamid = " .. SQLStr( steam:SteamID() ) .. ";")
    local data = sql.Query( "SELECT * FROM polytopia_inventory WHERE steamid = " .. sql.SQLStr( steam:SteamID() ) .. ";")
    if not steam then self:polychatNotify( 1, 'SteamID не найден.' ) return end
    if data == nil then
        sql.Query( "REPLACE INTO polytopia_inventory ( steamid, inventory ) VALUES ( " .. SQLStr( steam:SteamID() ) .. ", " .. SQLStr( "[}" ) .. " )" )
    end
    local newData = sql.Query( "SELECT inventory FROM polytopia_inventory WHERE steamid = " .. sql.SQLStr( steam:SteamID() ) .. ";")
    netstream.Start( self, 'polyinv.open', newData, polyinv.List, charInfo, polyinv.customCache )
end

function PL:giveItem( class )
    local createTable = sql.Query( "SELECT * FROM polytopia_inventory WHERE steamid = " .. sql.SQLStr( self:SteamID() ) .. ";")
    if createTable == nil then 
        sql.Query( "REPLACE INTO polytopia_inventory ( steamid, inventory ) VALUES ( " .. SQLStr( self:SteamID() ) .. ", " .. SQLStr( "[}" ) .. " )" )
    end

    local encoded = sql.Query( "SELECT inventory FROM polytopia_inventory WHERE steamid = " .. sql.SQLStr( self:SteamID() ) .. ";")
    local data = pon.decode( encoded[1].inventory )
    local fraq = 0

    if self:getCount( class ) >= polyinv.List[class].max then self:polychatNotify( 1, 'У вас максимальное кол-во "' .. polyinv.List[class].name .. '"' ) return end
    for k, v in pairs( data ) do
        local data_inv = polyinv.List[v].weight
        fraq = fraq + data_inv
    end

    if not polyinv.List[class] then self:polychatNotify( 1, 'Такого предмета не существует.' ) return end

    if fraq > 1.01 or fraq + polyinv.List[class].weight > 1.01 then self:polychatNotify( 1, 'Нет места.' ) return end

    table.insert( data, class )
    sql.Query( "REPLACE INTO polytopia_inventory ( steamid, inventory ) VALUES ( " .. SQLStr( self:SteamID() ) .. ", " .. SQLStr( pon.encode( data ) ) .. " )" )
end

Entity(1):giveItem( 'Несучка2' )

-- polyinv.createCustomItem({
--     name = 'Пушка 1',
--     class = 'Несучка2',
--     max = 3,
--     weight = 0.05,
--     func = 'gun',
--     canUse = false,
-- })   

PrintTable( polyinv.List )

function PL:hasItem( id )
    return self:getInventory_2()[id]
end

function PL:deleteItem( id )
    if self:hasItem( id ) then
        local notDel = self:getInventory_2()
            notDel[id] = nil 
        sql.Query( "REPLACE INTO polytopia_inventory ( steamid, inventory ) VALUES ( " .. SQLStr( self:SteamID() ) .. ", " .. SQLStr( pon.encode( notDel ) ) .. " )" )
    end
end

function PL:useItem( id )
    if self:hasItem( id ) then
        local itemCl = polyinv.List[self:getInventory_2()[id]]
        local isOk = polyinv.itemTypes[itemCl.func]( itemCl, self )
        if !isOk then
            self:deleteItem( id )
        end
    end
end

function PL:getCount( class )
    local encoded = sql.Query( "SELECT inventory FROM polytopia_inventory WHERE steamid = " .. sql.SQLStr( self:SteamID() ) .. ";")
    local data = pon.decode( encoded[1].inventory )
    local i = 0
    for k, v in pairs( data ) do
        if v == class then
            i = i + 1
        end
    end
    return i
end

hook.Add( "InitPostEntity", "some_unique_name", function()
    netstream.Hook( 'polyinv.sv-useItem', function( ply, id ) 
        ply:useItem( id )
    end)

    netstream.Hook( 'polyinv.sv-deleteItem', function( ply, id ) 
        ply:deleteItem( id )
    end)

    netstream.Hook( 'polyinv.sv-open', function( ply ) 
        ply:openInventory( ply:SteamID() )
    end)
end)

hook.Add( 'PlayerSay', 'polychars.openOnSay', function( ply, text )
    if ( text != '/me открыл рюкзак' ) then return end
    ply:openInventory( ply:SteamID() )
end)