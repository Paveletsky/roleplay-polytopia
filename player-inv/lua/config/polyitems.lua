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
    model = 'models/weapons/w_357.mdl',
    weight = 0.04,
    func = 'gun',
    canUse = true,
})

polyinv.registerItem({
    name = 'Тест',
    class = 'poly_item_test',
    max = 55,
    weight = 0.05,
    func = 'gun',
    canUse = false,
})

polyinv.registerCustomItem({
    name = 'Медаль Шона Эдисона',
    class = 'poly_custom_tester',
    desc = 'Посвящено первому человеку, который открыл этот рюкзак.',
    logo = 'poly/prize.png',
    max = 1,
    weight = 0.01,
    canUse = false,
    isCustom = true,
})   

-- PrintTable( Entity(1):GetBodyGroups() )