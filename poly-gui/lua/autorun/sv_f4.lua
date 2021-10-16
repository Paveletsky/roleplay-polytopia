local player = FindMetaTable( 'Player' )

util.AddNetworkString( 'lib.openf4Menu' )

hook.Add('ShowSpare2', 'library.f4', function( ply )
      net.Start( 'lib.openf4Menu' )
    net.Send( ply )
end)

netstream.Hook( 'changeChar2', function( ply, name, desc, skin, scale, bgroups )
    ply:SetNetVar( 'name', name)
        ply:SetNetVar( 'desc', desc )
            ply:saveData()
        ply:SetModelScale( scale )
    ply:SetModel( skin )

    local i = 1
    
    for k, v in pairs( ply:GetBodyGroups() ) do
            
        ply:SetBodygroup( v['id'], tonumber( bgroups[i] ) )
            i = i + 1
        ply:SetPData( 'mdl_scale', scale )
        ply:SetPData( 'mdl_skin', skin )
        ply:SetNetVar( 'mdl_skin', skin )
        ply:SetPData( 'mdl_bg', util.TableToJSON( bgroups ) )

    end

end)

netstream.Hook( 'library.loadData', function( ply )
        ply:loadData()
    ply:loadModel()
end)
--