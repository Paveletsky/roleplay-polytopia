local meta = FindMetaTable( 'Player' )

CFGspPos = {

    '-5710, -328, -42',

    '-5634, -340, -42',

    '-5539, -341, -42',

    '-5539, -344, -42',

    '-4290, 432, 92',

    '-4283, 505, 92',

    '-4277, 600, 92',

}

namesTable = {

	'Джэк Старший',
	
    'Винсент Лейн',
	
    'Винчензо Чили',
	
    'Йозеф Чарк',
	
    'Рэнди Армстронг',
	
    'Кристофер Уайтфилд',
	
    'Джон Мэтьюс',
	
    'Джеймс Кейтфилд',
	
    'Дин Йеванс',

	'Пол Роланд',

	'Джимми Стюарт',

	'Клифолд Бэверли',

	'Брайан Феллер',

	'Ларри Бэнсон',

	'Рудольф Тэйту',

	'Луис Нельсон',

	'Грант Шультц',

	'Джон Бёрс',

	'Стивен Дайк',

}

descriptionList = {

    'Парень, лицо побитое, на вид ему около 27 лет.',

    'Молодой человек низкого роста, худощавого телосложения, с редкими короткими курчавыми волосами рыжего цвета.',

    'Мужчина высокого роста, стройный, вдоль глаза имеется шрам.',

    'Измученный парень, под глазами мешки.',

    'Мужчина 30-ти лет, большие выразительные глаза с ироническим взглядом.',

}


--
-- local functions
--

local function randSpawn()

    local pls = parseCoords( CFGspPos[math.random( #CFGspPos )] )

      local position = Vector( tonumber(pls[1]), tonumber(pls[2]), tonumber(pls[3]) )

    return position

end


--
-- global functions
--

function library.toKeys(tbl)

	local out = {}
	for i, v in ipairs(tbl) do
		out[v] = true
	end

	return out

end



function roundNum(pos) -- округление векторных координат для глобального использование

    pos.x = math.Round(pos.x)

        pos.y = math.Round(pos.y)

    pos.z = math.Round(pos.z)

  return pos

end


function parseCoords(position)

    local t = {}
		
        for s in string.gmatch( position, "[-%d]+" ) do
		
        	t[#t + 1] = tonumber( s )
		
        end
    
    return t

end


--
-- characters
--


-- function meta:saveData()

-- 	self:SetPData( 'name', self:GetNetVar( 'name' ) ) self:SetPData( 'desc', self:GetNetVar( 'desc' ) )

-- end


-- function meta:loadData( )

--     if self:GetPData( 'name' or 'desc' or 'mdl_skin' ) == nil then 
    
--         self:SetPData( 'name', table.Random( namesTable ) ) 

--             self:SetPData( 'desc', table.Random( descriptionList ) ) 

--                 self:SetPData( 'mdl_skin', table.Random( self:getJobTable()['model'] ) ) 
                
--                 -- netvars -- 
        
--             self:SetNetVar( 'name', table.Random( namesTable ) ) 
        
--         self:SetNetVar( 'desc', table.Random( descriptionList ) )

--     else
        
--         self:SetNetVar( 'name', self:GetPData( 'name' ) ) 
        
--         self:SetNetVar( 'desc', self:GetPData( 'desc' ) )
    
--     end

-- end


function meta:loadPosition()

	local lPos = parseCoords( self:GetPData('position') )

    if self:GetPData('position') != nil then 
	    self:SetPos( Vector( lPos[1], lPos[2], lPos[3] ) )
    else self:randSpawn() end

end

-- function meta:loadModel()

--     -- local bgroups = util.JSONToTable( self:GetPData( 'mdl_bg' ) )
--     if self:GetPData( 'mdl_skin' ) == nil then 
-- 	    self:SetModel( table.Random( self:getJobTable()['model'] ) )
--     else 
--         self:SetModel( self:GetPData( 'mdl_skin' ) )
--     end

-- end

netstream.Hook( 'entlib.becomeJob', function( ply, key )
	ply:changeTeam( key, true, true )
end)


netstream.Hook( 'entlib.jobsCategory', function( ply, cat, ent ) 
  local tab = util.JSONToTable(file.Read("entlib-jobscategory.json", "DATA"))
  tab[cat][#tab[cat] + 1] = tostring( ent )
  file.Write("entlib-jobscategory.json",util.TableToJSON(tab, true))
end)


--
-- tests
--
