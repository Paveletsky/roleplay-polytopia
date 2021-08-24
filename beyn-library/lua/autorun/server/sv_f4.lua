function openF4( ply )
    netstream.Start( ply, 'startMenu' )
end

hook.Add( 'ShowSpare2', 'f4menuHook', openF4 )

netstream.Hook( 'changeChar2', function( ply, name, desc )
    ply:SetPData( 'name', name)
    ply:SetPData( 'desc', desc )
end)