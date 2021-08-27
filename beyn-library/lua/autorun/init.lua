library = library or {}

meta = FindMetaTable( 'Player' )

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

function library.server(path)

	path = path .. '.lua'
	if SERVER then include(path) end

end

function library.client(path)

	path = path .. '.lua'
	if SERVER then AddCSLuaFile(path) end
	if CLIENT then include(path) end

end

function library.shared(path)

	path = path .. '.lua'
	if SERVER then AddCSLuaFile(path) end
	include(path)

end

function library.module(path)

	if file.Exists(path .. '/shared.lua', 'LUA') then library.shared(path .. '/shared') end
	if file.Exists(path .. '/server.lua', 'LUA') then library.server(path .. '/server') end
	if file.Exists(path .. '/client.lua', 'LUA') then library.client(path .. '/client') end

end

--
--
--

function parseCoords(position)
    local t = {}
		for s in string.gmatch( position, "[-%d]+" ) do
			t[#t + 1] = tonumber( s )
		end
    return t
end

function meta:saveData( ply )
	self:SetPData( 'name', self:GetNetVar( 'name' ) ) self:SetPData( 'desc', self:GetNetVar( 'desc' ) ) self:SetPData( 'model', self:GetModel() )
end

function meta:loadData( ply )
local getMdl = table.Random( self:getJobTable()['model'] )
	if self:GetPData( 'name' or 'desc' or 'model' ) == nil then self:SetPData( 'name', table.Random( namesTable ) ) self:SetPData( 'desc', ' ' ) self:SetPData( 'model', getMdl ) -- netvars -- 
		self:SetNetVar( 'name', table.Random( namesTable ) ) self:SetNetVar( 'desc', ' ' )
	else
		self:SetNetVar( 'name', self:GetPData( 'name' ) ) self:SetNetVar( 'desc', self:GetPData( 'desc' ) )
	end	
end

function meta:loadPosition()
	local pos1 = parseCoords( self:GetPData('position') or '0, 0, -90' )
	self:SetPos( Vector( pos1[1], pos1[2], pos1[3] ) )
end

function meta:loadModel()
	self:SetModel( self:GetPData( 'model' ) )
end

library.shared('library/lib_init')

-- Entity(1):loadPosition()
