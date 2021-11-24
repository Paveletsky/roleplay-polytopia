--
polyinv.List = {}

function polyinv.registerItem( data )
    local class = data.class
    polyinv.List[class] = data
end

polyinv.registerItem({
    name = 'Палка',
    class = 'arrest_stick',
    max = 2,
    logo = 'poly/cake.png',
    weight = 0.05,
    desc = 'Обычная палочка =)',
})

polyinv.registerItem({
    name = 'Тест',
    class = 'lol',
    max = 1,
    weight = 0.07,
})

-- Entity(1):giveItem( 'arrest_stick' )

-- Entity(1):initInventory()
-- Entity(1):giveItem( 'lol' )

-- PrintTable( Entity(1).cache_inv )
-- PrintTable( polyinv.List )
