polyinv.List = {}

function polyinv.registerItem( data )
    local class = data.class
    polyinv.List[class] = data
end

polyinv.registerItem({
    name = 'Палка',
    class = 'arrest_stick',
    max = 5,
    logo = 'poly/cake.png',
    weight = 0.04,
    canUse = false,
})

polyinv.registerItem({
    name = 'Тест',
    class = 'lol',
    max = 3,
    weight = 0.05,
    canUse = false,
})