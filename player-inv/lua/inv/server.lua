local PL = FindMetaTable( 'Player' )

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
    if fraq > 1.1 or fraq + polyinv.List[class].weight > 1.1 then self:polychatNotify( 1, 'Нет места.' ) return end
    netstream.Start( self, 'polyinv.openMenu' )
    netstream.Start( self, 'polyinv.giveItem', class )
    table.insert( self.cache_inv, class )
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
end )

-- Entity(1):Spawn()

-- Entity(1):giveItem( 'arrest_stick' )

-- Entity(1):initInventory()
-- Entity(1):giveItem( 'lol' )

-- PrintTable( Entity(1).cache_inv )
-- PrintTable( polyinv.List )