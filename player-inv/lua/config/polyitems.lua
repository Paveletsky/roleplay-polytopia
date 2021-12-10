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
    name = 'Неизвестная пушка',
    class = 'weapon_357',
    desc = 'Нет описания',
    max = 3,
    logo = 'poly/gun.png',
    model = 'models/weapons/w_357.mdl',
    weight = 0.04,
    func = 'gun',
    canUse = true,
})

polyinv.registerCustomItem({
    name = 'Медаль Шона Эдисона',
    class = 'poly_custom_tester',
    desc = 'Посвящено первому человеку, который открыл этот рюкзак.',
    logo = 'poly/prize.png',
    max = 1,
    weight = 0.01,
    canUse = false,
    isCustom = false,
})   

-- Entity(1):GiveItem 'poly_custom_tester'

-- PrintTable( Entity(1):GetBodyGroups() )