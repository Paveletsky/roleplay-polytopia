function openF4( ply )
    netstream.Start( ply, 'startMenu' )
end

hook.Add( 'ShowSpare2', 'f4menuHook', openF4 )