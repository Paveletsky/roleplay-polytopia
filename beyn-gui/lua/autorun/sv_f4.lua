local player = FindMetaTable( 'Player' )

util.AddNetworkString( 'lib.openf4Menu' )

hook.Add('ShowSpare2', 'library.f4', function( ply )
      net.Start( 'lib.openf4Menu' )
    net.Send( ply )
end)

netstream.Hook( 'changeChar2', function( ply, name, desc )
    ply:SetNetVar( 'name', name)
        ply:SetNetVar( 'desc', desc )
    ply:saveData()
end)

netstream.Hook( 'library.loadData', function( ply )
        ply:loadData()
    ply:loadModel()
end)