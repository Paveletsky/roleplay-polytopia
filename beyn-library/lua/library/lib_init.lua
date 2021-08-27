--
-- connect methods
--

GM = GAMEMODE or {}

library.shared 'netlib/netwrapper/sh_netwrapper'
library.client 'netlib/netwrapper/cl_netwrapper'
library.server 'netlib/netwrapper/sv_netwrapper'

library.shared 'netlib/netstream'
library.shared 'netlib/netstream2'

library.module 'netlib/netwrapper'
library.module 'panels/welcome'

library.client 'panels/welcome/cl_welcome'
library.server 'panels/welcome/sv_welcome'

library.shared 'netlib/pon'
library.shared 'netlib/von'

function roundNum(pos)
    pos.x = math.Round(pos.x)
        pos.y = math.Round(pos.y)
    pos.z = math.Round(pos.z)
  return pos
end

function GM:PlayerDisconnected(ply)
    local pos = roundNum( ply:GetPos() )
        local posit = string.format( '%s, %s, %s', pos.x, pos.y, pos.z )
        ply:SetPData( 'position', posit )
    ply:saveData()
end

function GM:PlayerSpawn(ply)

    ply:Freeze(false)
      ply:loadData()
    ply:loadModel()

    for k, v in pairs( GM.Config.DefaultWeapons  ) do
        ply:Give( v )
    end
        
    for k, v in pairs( ply:getJobTable()['weapons'] ) do
        ply:Give( v )
    end

end

hook.Add('PlayerInitialSpawn', 'lib.loadProfile', function( ply )
    netstream.Start( ply, 'lib.welcomeOpen' )
    timer.Simple(5, function()
        ply:loadData()
            ply:loadModel()
        ply:Freeze(true)
    end)
end)

hook.Add( "PlayerHurt", "lib.damageReact", function( ply )
	ply:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 253 ), 0.1, 0.1 )
end )


local CFGspPos = {
    '964, 623, -144',
    '880, 253, -144',
    '801, -215, -144',
    '872, -631, -144',
}

local function randSpawn()

    local pls = parseCoords( CFGspPos[math.random( #CFGspPos )] )
    local position = Vector( tonumber(pls[1]), tonumber(pls[2]), tonumber(pls[3]) )
    return position
-- :SetPos( Vector( tonumber(pls[1]), tonumber(pls[2]), tonumber(pls[3]) ) )

end

