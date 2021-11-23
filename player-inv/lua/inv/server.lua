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

polyinv.registerItem({
    class = 'arrest_stick',
})

PrintTable( polyinv.List )