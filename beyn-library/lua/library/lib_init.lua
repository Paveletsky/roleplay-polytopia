--
-- connect methods
--


library.shared 'netlib/netwrapper/sh_netwrapper'
library.client 'netlib/netwrapper/cl_netwrapper'
library.server 'netlib/netwrapper/sv_netwrapper'

library.shared 'netlib/netstream'
library.shared 'netlib/netstream2'

library.module 'netlib/netwrapper'
library.module 'panels/welcome'

library.client 'panels/welcome/cl_welcome'
library.server 'panels/welcome/sv_welcome'

library.server 'core/funcs'
library.module 'core'

library.shared 'netlib/pon'
library.shared 'netlib/von'


--
-- игровые хуки
--

GM = GAMEMODE or {}


function GM:PlayerHurt( ply )

	ply:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 253 ), 0.1, 0.1 )

end


function GM:PlayerDisconnected( ply )

    local pos = roundNum( ply:GetPos() )

       local posit = string.format( '%s, %s, %s', pos.x, pos.y, pos.z )

    ply:SetPData( 'position', posit )


end


function GM:PlayerSpawn( ply )

    ply:Freeze( false )

    for k, v in pairs( GM.Config.DefaultWeapons  ) do

        ply:Give( v )

    end
        
    for k, v in pairs( ply:getJobTable()['weapons'] ) do

        ply:Give( v )

    end

end


hook.Add('PlayerInitialSpawn', 'lib.player-spawn', function( ply )

    timer.Create( 'lib.player-init', 1, 1, function()
    
        ply:Freeze( true )

        netstream.Start( ply, 'lib.welcomeOpen' )

    end)
    
end)

netstream.Start( ply, 'lib.welcomeMsg' )