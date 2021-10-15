--
-- connect methods
--

library.module 'mode/darkrp_config'
library.module 'mode/darkrp_customthings'
library.module 'mode/darkrp_language'

library.shared 'netlib/netwrapper/sh_netwrapper'
library.client 'netlib/netwrapper/cl_netwrapper'
library.server 'netlib/netwrapper/sv_netwrapper'

library.shared 'netlib/netstream'
library.shared 'netlib/netstream2'

library.client 'panels/welcome/cl_welcome'
library.server 'panels/welcome/sv_welcome'

library.server 'core/funcs'

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

    for k, v in pairs( GM.Config.DefaultWeapons  ) do

        ply:Give( v )

    end
        
    for k, v in pairs( ply:getJobTable()['weapons'] ) do

        ply:Give( v )

    end

end


hook.Add('PlayerInitialSpawn', 'lib.player-spawn', function( ply )

    timer.Create( 'lib.player-init', 1, 1, function()

        timer.Remove( 'lib.player-init' )

        netstream.Start( ply, 'lib.welcomeOpen' )

    end)
    
end)

Entity(1):loadData()