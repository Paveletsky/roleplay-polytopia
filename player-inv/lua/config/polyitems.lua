polyinv.List = {}
polyinv.itemTypes = {
    gun = function( item, ply )
        ply:Give(item.class)
    end,
}

function polyinv.registerItem( data )
    local class = data.class
    polyinv.List[class] = data
end

polyinv.registerItem({
    name = 'Револьвер',
    class = 'weapon_357',
    max = 55,
    logo = 'poly/cake.png',
    weight = 0.04,
    func = 'gun',
    canUse = true,
})

polyinv.registerItem({
    name = 'Тест',
    class = 'lol',
    max = 3,
    weight = 0.05,
    func = 'gun',
    canUse = false,
})

-- Entity(1):giveItem( 'weapon_357' )

-- PrintTable( Entity(1):GetBodyGroups() )