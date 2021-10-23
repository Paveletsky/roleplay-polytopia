--
-- connect methods
--

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

library.shared 'panels/derma'

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

    ply:SetNetVar( 'character', ply:GetPData( 'character' ) )

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

        ply:getCharacters()

        netstream.Start( ply, 'lib.welcomeOpen' )

    end)
    
end)

function GM:PostPlayerDeath( ply )
    netstream.Start( ply, 'lib.welcomeOpen' )
end


hook.Add('StartCommand', 'move', function(ply, cmd)

    if cmd:KeyDown(IN_SPEED) or ply:IsSprinting() then
        local fwd = cmd:GetForwardMove()
        local side = cmd:GetSideMove()
        if fwd < 0 or (fwd == 0 and side ~= 0) then
            cmd:RemoveKey(IN_SPEED)
            cmd:RemoveKey(IN_WALK)
        end
    end

    if cmd:KeyDown(IN_JUMP) then
        if ply:GetJumpPower() == 0 and not ply:InVehicle() then
            cmd:RemoveKey(IN_JUMP)
        end
    end

end)

if CLIENT then
    local lastCrouch, crouching = 0, false
    hook.Add('PlayerBindPress', 'dbg-move', function(ply, bind, pressed)

    	if bind == '+duck' or bind == 'duck' then
    		if crouching then
    			RunConsoleCommand('-duck')
    			crouching = false
    		else
    			if CurTime() - lastCrouch < 0.2 then
    				RunConsoleCommand('+duck')
    				crouching = true
    			end
    			lastCrouch = CurTime()
    		end
    	end

    end)
end


// whitelist server

if SERVER then

    local allowed = {
        [ "76561198021443322" ] = true,
        [ '765611983308226091' ] = true,
    }

    hook.Add( "CheckPassword", "access_whitelist", function( steamID64 )
        if not allowed[ steamID64 ] then
            return false, "Сервер в разработке. Наш проект - https://discord.gg/tFYctGUXMA"
        end
    end )

end

if CLIENT then

    concommand.Add( 'polychars_getmychars', function( ply )

        print( #pon.decode( ply:GetNetVar 'characters'  ))
        PrintTable( pon.decode( ply:GetNetVar 'characters' )) 

    end)
    
end