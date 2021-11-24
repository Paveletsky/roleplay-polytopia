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
    netstream.Start( self, 'polyinv.open', data )
end

Entity(1):openInventory( 'STEAM_0:0:30588797' )

function PL:initInventory()
    self.cache_inv = {}
    netstream.Start( self, 'polyinv.initialize' )
end

function PL:giveItem( class )
    if self:getCount( class ) >= polyinv.List[class].max then self:polychatNotify( 1, 'У вас максимальное кол-во "' .. polyinv.List[class].name .. '"' ) return end
    local fraq = 0
    for k, v in pairs( self.cache_inv ) do
        local data_inv = polyinv.List[v].weight
        fraq = fraq + data_inv
    end
    self:getCount( class )
    if not polyinv.List[class] then self:polychatNotify( 1, 'Такого предмета не существует.' ) return end
    if fraq > 1.01 or fraq + polyinv.List[class].weight > 1.01 then self:polychatNotify( 1, 'Нет места.' ) return end
    netstream.Start( self, 'polyinv.openMenu' )
    netstream.Start( self, 'polyinv.giveItem', class )
    table.insert( self.cache_inv, class )
end

function PL:useItem()

end

function PL:getCount( class )
    local i = 0
    for k, v in pairs( self.cache_inv ) do
        if v == class then
            i = i + 1
        end
    end
    netstream.Start( self, 'polyinv.openMenu' )
    return i
end

hook.Add( "PlayerSay", "polyinv.menuOnChat", function( ply, text )
    if ( text != '/me открыл рюкзак' ) then return end
    netstream.Start( self, 'polyinv.openMenu' )
end)

local st = player.GetBySteamID( 'STEAM_0:0:30588797' )

-- Entity(1):giveItem( 'arrest_stick' )

-- Entity(1):initInventory()