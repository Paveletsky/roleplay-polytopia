polyinv.List = {}

local PL = FindMetaTable( 'Player' )

if ( !sql.TableExists( "polytopia_inventory" ) ) then
    sql.Query( 'CREATE TABLE IF NOT EXISTS polytopia_inventory( steamid TEXT NOT NULL PRIMARY KEY , inventory TEXT )' )    
end

function PL:getInventory(  )
    local val = sql.Query("SELECT chars FROM polytopia_inventory WHERE steamid = " .. SQLStr( self:SteamID() ) )
    return val
end

function PL:openInventory( owner )
    owner = player.GetBySteamID( owner )
    local data = sql.Query( "SELECT * FROM polytopia_inventory WHERE steamid = " .. sql.SQLStr( owner:SteamID() ) .. ";")
    if data == nil then 
        sql.Query( "REPLACE INTO polytopia_inventory ( steamid, inventory ) VALUES ( " .. SQLStr( owner:SteamID() ) .. ", " .. SQLStr( "" ) .. " )" )
    end
    netstream.Start( self, 'polyinv.open', data, polyinv.List )
end

function PL:initInventory()
    self.cache_inv = {}
    netstream.Start( self, 'polyinv.initialize' )
end

function PL:giveItem( class )
    local data = sql.Query( "SELECT * FROM polytopia_inventory WHERE steamid = " .. sql.SQLStr( self:SteamID() ) .. ";")
    if self:getCount( class ) >= polyinv.List[class].max then self:polychatNotify( 1, 'У вас максимальное кол-во "' .. polyinv.List[class].name .. '"' ) return end
    local fraq = 0
    for k, v in pairs( data ) do
        local data_inv = polyinv.List[v].weight
        fraq = fraq + data_inv
    end
    self:getCount( class )
    if not polyinv.List[class] then self:polychatNotify( 1, 'Такого предмета не существует.' ) return end
    if fraq > 1.01 or fraq + polyinv.List[class].weight > 1.01 then self:polychatNotify( 1, 'Нет места.' ) return end
    netstream.Start( self, 'polyinv.openMenu' )
    
    local cache = {}
    table.insert( cache, class )
    sql.Query( "REPLACE INTO polytopia_inventory ( steamid, inventory ) VALUES ( " .. SQLStr( self:SteamID() ) .. ", " .. SQLStr( cache ) .. " )" )
end

function PL:useItem()

end

function PL:getCount( class )
    local data = sql.Query( "SELECT * FROM polytopia_inventory WHERE steamid = " .. sql.SQLStr( self:SteamID() ) .. ";")
    local i = 0
    for k, v in pairs( data ) do
        if v == class then
            i = i + 1
        end
    end
    netstream.Start( self, 'polyinv.openMenu' )
    return i
end

function polyinv.registerItem( data )
    local class = data.class
    polyinv.List[class] = data
end

polyinv.registerItem({
    name = 'Палка',
    class = 'arrest_stick',
    max = 2,
    logo = 'poly/cake.png',
    weight = 0.04,
    canUse = false,
})

polyinv.registerItem({
    name = 'Тест',
    class = 'lol',
    max = 3,
    weight = 0.05,
    canUse = false,
})

Entity(1):openInventory( 'STEAM_0:0:30588797' )
-- Entity(1):giveItem( 'lol' )