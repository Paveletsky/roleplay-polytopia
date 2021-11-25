local PL = FindMetaTable( 'Player' )

if ( !sql.TableExists( "polytopia_inventory" ) ) then
    sql.Query( 'CREATE TABLE IF NOT EXISTS polytopia_inventory( steamid TEXT NOT NULL PRIMARY KEY , inventory TEXT )' )    
end

function PL:getInventory(  )
    local val = sql.Query("SELECT chars FROM polytopia_inventory WHERE steamid = " .. SQLStr( self:SteamID() ) )
    return val
end

function PL:openInventory( owner )
    if not owner then self:polychatNotify( 1, 'SteamID не найден.' ) return end
    local steam = player.GetBySteamID( owner )
    local data = sql.Query( "SELECT * FROM polytopia_inventory WHERE steamid = " .. sql.SQLStr( steam:SteamID() ) .. ";")
    if not steam then self:polychatNotify( 1, 'SteamID не найден.' ) return end
    if data == nil then
        sql.Query( "REPLACE INTO polytopia_inventory ( steamid, inventory ) VALUES ( " .. SQLStr( steam:SteamID() ) .. ", " .. SQLStr( "[}" ) .. " )" )
    end
    local newData = sql.Query( "SELECT inventory FROM polytopia_inventory WHERE steamid = " .. sql.SQLStr( steam:SteamID() ) .. ";")
    netstream.Start( self, 'polyinv.open', newData, polyinv.List )
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
    self:getCount( class )
    if not polyinv.List[class] then self:polychatNotify( 1, 'Такого предмета не существует.' ) return end
    if fraq > 1.01 or fraq + polyinv.List[class].weight > 1.01 then self:polychatNotify( 1, 'Нет места.' ) return end

    table.insert( data, class )
    sql.Query( "REPLACE INTO polytopia_inventory ( steamid, inventory ) VALUES ( " .. SQLStr( self:SteamID() ) .. ", " .. SQLStr( pon.encode( data ) ) .. " )" )
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