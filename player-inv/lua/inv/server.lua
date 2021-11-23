polyinv = {}
polyinv.List = {}

local PL = FindMetaTable( 'Player' )

function polyinv.registerItem( data )
    local class = data.class
    polyinv.List[class] = data
end

function PL:initInventory()
    self.cache_inv = {}
end

function PL:giveItem( class )
    if not polyinv.List[class] then self:polychatNotify( 1, 'Такого предмета не существует.' ) return end
    table.insert( self.cache_inv, class )
end

polyinv.registerItem({
    class = 'arrest_stick',
    -- max = 2,
})

-- Entity(1):initInventory()
-- Entity(1):giveItem( 'arrest_stick' )

-- PrintTable( Entity(1).cache_inv )
-- PrintTable( polyinv.List )
