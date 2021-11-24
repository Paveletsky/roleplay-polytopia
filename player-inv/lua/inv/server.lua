local PL = FindMetaTable( 'Player' )

function PL:initInventory()
    self.cache_inv = {}
    netstream.Start( self, 'polyinv.initialize' )
end

function PL:giveItem( class )
    local fraq = 0
    for k, v in pairs( self.cache_inv ) do
        local data_inv = polyinv.List[v].weight
        fraq = fraq + data_inv
    end
    if not polyinv.List[class] then self:polychatNotify( 1, 'Такого предмета не существует.' ) return end
    if fraq > 1.1 or fraq + polyinv.List[class].weight > 1.1 then self:polychatNotify( 1, 'Нет места.' ) return end
    netstream.Start( self, 'polyinv.openMenu' )
    netstream.Start( self, 'polyinv.giveItem', class )
    table.insert( self.cache_inv, class )
end

-- polyinv.registerItem({
--     class = 'lol',
--     max = 2,
-- })

-- Entity(1):giveItem( 'arrest_stick' )

-- Entity(1):initInventory()
Entity(1):giveItem( 'lol' )

-- PrintTable( Entity(1).cache_inv )
-- PrintTable( polyinv.List )