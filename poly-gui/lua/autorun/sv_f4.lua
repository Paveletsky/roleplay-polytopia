local player = FindMetaTable( 'Player' )

util.AddNetworkString( 'lib.openf4Menu' )

hook.Add('ShowSpare2', 'library.f4', function( ply )
      net.Start( 'lib.openf4Menu' )
    net.Send( ply )
end)

netstream.Hook( 'changeChar2', function( ply, name, desc, skin, scale, bgroups )

    ply:SetPData( 'character', pon.encode({
        name = name,
        desc = desc,
        scale = scale,
        skin = skin,
        bgroups = bgroups,
    }))

    ply:SetNetVar( 'character', ply:GetPData( 'character' ) )

    local i = 1
    for k, v in pairs( ply:GetBodyGroups() ) do
        ply:SetBodygroup( v['id'], tonumber( bgroups[i] ) )
            i = i + 1
    end

    ply:SetModel( skin )
    ply:SetModelScale( scale )

end)

netstream.Hook( 'library.loadData', function( ply )
        ply:loadData()
    ply:loadModel()
end)