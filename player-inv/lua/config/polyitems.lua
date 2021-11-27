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


function polyinv.registerCustomItem( data )
    local class = data.class
    polyinv.List[class] = data
end

polyinv.registerItem({
    name = 'Револьвер',
    class = 'weapon_357',
    max = 3,
    logo = 'poly/gun.png',
    weight = 0.04,
    func = 'gun',
    canUse = true,
})

polyinv.registerItem({
    name = 'Тест',
    class = 'poly_item_test',
    max = 3,
    weight = 0.05,
    func = 'gun',
    canUse = false,
})

polyinv.registerCustomItem({
    name = 'Медаль Шона Эдисона',
    class = 'poly_custom_tester',
    desc = 'Посвящено первому человеку, который открыл этот рюкзак.',
    logo = 'poly/prize.png',
    model = 'models/props_lab/huladoll.mdl',
    max = 1,
    weight = 0.01,
    canUse = false,
    isCustom = true,
})   

-- Entity(1):giveItem( 'poly_custom_tester' )

-- PrintTable( Entity(1):GetBodyGroups() )